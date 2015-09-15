//
//  SFBasicDataSource.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 07/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"

/// A subclass of ITCDataSource that manages a single section of items backed by an NSArray.
@interface SFBasicDataSource : SFDataSource

/// The items represented by this data source. This property is KVC compliant for mutable changes via -mutableArrayValueForKey:.
@property (nonatomic, copy) NSArray *items;

/// Set the items with optional animation. By default, setting the items is not animated.
- (void)setItems:(NSArray *)items animated:(BOOL)animated;

- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)setItems:(NSArray *)items silenlty:(BOOL)silently;

//- (void)updateItem:(SFObject *)object;
//- (void)removeItem:(SFObject *)object;

@end