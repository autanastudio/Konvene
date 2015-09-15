/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  AAPLLoadableContentStateMachine — This is the state machine that manages transitions for all loadable content.
  AAPLLoading — This is a signalling object used to simplify transitions on the statemachine and provide update blocks.
  AAPLContentLoading — A protocol adopted by the AAPLDataSource class for loading content.
  
 */

#import "SFContentLoading.h"
#import <libkern/OSAtomic.h>

#define DEBUG_ITCLOADING 0

NSString * const SFLoadStateInitial = @"Initial";
NSString * const SFLoadStateLoadingContent = @"LoadingState";
NSString * const SFLoadStateLoadingNextContent = @"LoadingNextState";
NSString * const SFLoadStateRefreshingContent = @"RefreshingState";
NSString * const SFLoadStateContentLoaded = @"LoadedState";
NSString * const SFLoadStateNoContent = @"NoContentState";
NSString * const SFLoadStateError = @"ErrorState";
NSString * const SFLoadStateErrorNext = @"ErrorNextState";


@implementation SFLoadableContentStateMachine

- (instancetype)init
{
    self = [super init];
    self.currentState = SFLoadStateInitial;
    self.validTransitions = @{
                              SFLoadStateInitial : @[SFLoadStateLoadingContent],
                              SFLoadStateLoadingContent : @[SFLoadStateContentLoaded, SFLoadStateNoContent, SFLoadStateError],
                              SFLoadStateLoadingNextContent : @[SFLoadStateContentLoaded, SFLoadStateErrorNext],
                              SFLoadStateRefreshingContent : @[SFLoadStateContentLoaded, SFLoadStateNoContent, SFLoadStateError],
                              SFLoadStateContentLoaded : @[SFLoadStateRefreshingContent, SFLoadStateNoContent, SFLoadStateError, SFLoadStateLoadingNextContent],
                              SFLoadStateNoContent : @[SFLoadStateRefreshingContent, SFLoadStateContentLoaded, SFLoadStateError],
                              SFLoadStateError : @[SFLoadStateLoadingContent, SFLoadStateRefreshingContent, SFLoadStateNoContent, SFLoadStateContentLoaded],
                              SFLoadStateErrorNext : @[SFLoadStateLoadingNextContent, SFLoadStateRefreshingContent]
                              };
    return self;
}

@end



@interface SFLoading()
@property (nonatomic, copy) void (^block)(NSString *newState, NSError *error, SFLoadingUpdateBlock update);
@end

@implementation SFLoading
#if DEBUG
{
    int32_t _complete;
}
#endif

+ (instancetype)loadingWithCompletionHandler:(void(^)(NSString *state, NSError *error, SFLoadingUpdateBlock update))handler
{
    NSParameterAssert(handler != nil);
    SFLoading *loading = [[self alloc] init];
    loading.block = handler;
    loading.current = YES;
    return loading;
}

#if DEBUG
- (void)aaplLoadingDebugDealloc
{
    if (OSAtomicCompareAndSwap32(0, 1, &_complete))
#if DEBUG_ITCLOADING
        NSAssert(false, @"No completion methods called on AAPLLoading instance before dealloc called.");
#else
        NSLog(@"No completion methods called on AAPLLoading instance before dealloc called. Break in -[AAPLLoading aaplLoadingDebugDealloc] to debug this.");
#endif
}

- (void)dealloc
{
    // make this easier to debug by having a separate method for a breakpoint.
    [self aaplLoadingDebugDealloc];
}
#endif

- (void)_doneWithNewState:(NSString *)newState error:(NSError *)error update:(SFLoadingUpdateBlock)update
{
#if DEBUG
    if (!OSAtomicCompareAndSwap32(0, 1, &_complete))
        NSAssert(false, @"completion method called more than once");
#endif

    void (^block)(NSString *state, NSError *error, SFLoadingUpdateBlock update) = _block;

    dispatch_async(dispatch_get_main_queue(), ^{
        block(newState, error, update);
    });

    _block = nil;
}

- (void)ignore
{
    [self _doneWithNewState:nil error:nil update:nil];
}

- (void)done
{
    [self _doneWithNewState:SFLoadStateContentLoaded error:nil update:nil];
}

- (void)updateWithContent:(SFLoadingUpdateBlock)update
{
    [self _doneWithNewState:SFLoadStateContentLoaded error:nil update:update];
}

- (void)doneWithError:(NSError *)error
{
    NSString *newState = error ? SFLoadStateError : SFLoadStateContentLoaded;
    [self _doneWithNewState:newState error:error update:nil];
}

- (void)updateWithNoContent:(SFLoadingUpdateBlock)update
{
    [self _doneWithNewState:SFLoadStateNoContent error:nil update:update];
}
@end

