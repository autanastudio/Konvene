//
//  NSObject+KVOBlock.m
//  SFKit
//
//  Created by Yarik Smirnov on 10/10/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "NSObject+KVOBlock.h"
#import <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

static void * const SFObserverMapKey = @"SFObserverMapKey";
static dispatch_queue_t SFObserverMutationQueue = NULL;

static dispatch_queue_t SFObserverMutationQueueCreatingIfNecessary()
{
    static dispatch_once_t queueCreationPredicate = 0;
    dispatch_once(&queueCreationPredicate, ^{
        SFObserverMutationQueue = dispatch_queue_create("com.sfcd.skit.observerMutationQueue", 0);
    });
    return SFObserverMutationQueue;
}



@interface SFObserverTrampoline : NSObject
{
    __weak id _observee; // Hold strong reference to observee object.
    NSString *_keyPath;
    SFBlockObserver _block;
    volatile int32_t _cancellationPredicate;
    NSKeyValueObservingOptions _options;
}
@property (nonatomic, strong) NSString *keyPath;
@property (readonly) id token;

- (SFObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(SFBlockObserver)block;

- (void)startObserving;

@end

@implementation SFObserverTrampoline
@synthesize keyPath = _keyPath;

static void * const SFObserverTrampolineContext = @"SFObserverTrampolineContext";

- (void)dealloc
{
    [self cancelObservationOfObject:_observee];
}

- (SFObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(SFBlockObserver)block
{
    self = [super init];
    if (!self)
        return nil;

    _block = [block copy];
    _keyPath = [keyPath copy];
    _options = options;
    _observee = obj;
    return self;
}

- (void)startObserving
{
    [_observee addObserver:self forKeyPath:_keyPath options:_options context:SFObserverTrampolineContext];
}

- (id)token
{
    return [NSValue valueWithPointer:&_block];
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == SFObserverTrampolineContext && !_cancellationPredicate) {
        _block(object, change, self.token);
    }
}

- (void)cancelObservationOfObject:(id)observee
{
    if (OSAtomicCompareAndSwap32(0, 1, &_cancellationPredicate)) {

        // Make sure we don't remove ourself before addObserver: completes
        if (_options & NSKeyValueObservingOptionInitial) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [observee removeObserver:self forKeyPath:_keyPath context:SFObserverTrampolineContext];
            });
        }
        else {
            [observee removeObserver:self forKeyPath:_keyPath context:SFObserverTrampolineContext];
        }
    }
}

@end



@implementation NSObject (KVOBlock)

- (id)sf_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options withBlock:(SFBlockObserver)block
{
    __block id token = nil;

    __block SFObserverTrampoline *trampoline = nil;

    dispatch_sync(SFObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *dict = objc_getAssociatedObject(self, SFObserverMapKey);
        if (!dict) {
            dict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, SFObserverMapKey, dict, OBJC_ASSOCIATION_RETAIN);
        }
        trampoline = [[SFObserverTrampoline alloc] initObservingObject:self keyPath:keyPath options:(NSKeyValueObservingOptions)options block:block];
        token = trampoline.token;
        dict[token] = trampoline;
    });

    // To avoid deadlocks when using appl_removeObserverWithBlockToken from within the dispatch_sync (for a one-shot with NSKeyValueObservingOptionInitial), start observing outside of the sync.
    [trampoline startObserving];
    return token;
}

- (id)sf_addObserverForKeyPath:(NSString *)keyPath withBlock:(SFBlockObserver)block
{
    return [self sf_addObserverForKeyPath:keyPath options:NSKeyValueObservingOptionNew withBlock:block];
}

- (void)sf_removeObserver:(id)token
{
    dispatch_sync(SFObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, SFObserverMapKey);
        SFObserverTrampoline *trampoline = observationDictionary[token];
        if (!trampoline) {
            NSLog(@"Ignoring attempt to remove non-existent observer on %@ for token %@.", self, token);
            return;
        }
        [trampoline cancelObservationOfObject:self];
        [observationDictionary removeObjectForKey:token];

        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC. (FWIW, I believe this was fixed in Snow Leopard.)
        if ([observationDictionary count] == 0)
            objc_setAssociatedObject(self, SFObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN);
    });
}

- (void)sf_removeAllObservers
{
    dispatch_sync(SFObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, SFObserverMapKey);
        for (SFObserverTrampoline *trampoline in observationDictionary.allValues) {
            [trampoline cancelObservationOfObject:self];
        }
        [observationDictionary removeAllObjects];
        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC. (FWIW, I believe this was fixed in Snow Leopard.)
        if ([observationDictionary count] == 0)
            objc_setAssociatedObject(self, SFObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN);
    });
}

- (void)sf_removeObserverForKeyPath:(NSString *)keyPath
{
    dispatch_sync(SFObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, SFObserverMapKey);
        NSArray *allTrampolines = observationDictionary.allValues.copy;
        for (SFObserverTrampoline *trampoline in allTrampolines) {
            if ([trampoline.keyPath isEqualToString:keyPath]) {
                [trampoline cancelObservationOfObject:self];
                [observationDictionary removeObjectForKey:allTrampolines];
            }
        }
        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC. (FWIW, I believe this was fixed in Snow Leopard.)
        if ([observationDictionary count] == 0)
            objc_setAssociatedObject(self, SFObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN);
    });
}

@end
