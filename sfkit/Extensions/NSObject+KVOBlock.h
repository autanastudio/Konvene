//
//  NSObject+KVOBlock.h
//  SFKit
//
//  Created by Yarik Smirnov on 10/10.14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SFBlockObserver)(id obj, NSDictionary *change, id observer);

@interface NSObject (KVOBlock)

/// Add a block-based observer. Returns a token for use with removeObserverWithBlockToken:.
- (id)sf_addObserverForKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                     withBlock:(SFBlockObserver)block;
/**
 *  Add a block-based observer with NSKeyValueObservingOptionNew options value.
 *
 *  @param keyPath keyPath for observing
 *  @param block   observation block
 *
 *  @return Return token for removeObserver:
 */
- (id)sf_addObserverForKeyPath:(NSString *)keyPath withBlock:(SFBlockObserver)block;

/**
 *  Remove observer of object.
 *
 *  @param observer token returned in sf_addObserver
 */
- (void)sf_removeObserver:(id)observer;
/**
 *  Remove observer by specific keyPath;
 *
 *  @param keyPath keyPath of observer.
 */
- (void)sf_removeObserverForKeyPath:(NSString *)keyPath;
/**
 *  Removes all observing of self.
 */
- (void)sf_removeAllObservers;

@end
