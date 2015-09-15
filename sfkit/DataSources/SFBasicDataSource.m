 //
//  SFBasicDataSource.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 07/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFBasicDataSource.h"
#import "SFDataSource_Private.h"

@implementation SFBasicDataSource

- (void)resetContent
{
    [super resetContent];
    self.items = @[];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger itemIndex = indexPath.item;
    if (itemIndex < [_items count])
        return _items[itemIndex];
    
    return nil;
}

- (NSArray *)indexPathsForItem:(id)item
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger objectIndex, BOOL *stop) {
        if ([obj isEqual:item])
            [indexPaths addObject:[NSIndexPath indexPathForRow:objectIndex inSection:0]];
    }];
    return indexPaths;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndex:(NSUInteger)indexPath.row];
    [self removeItemsAtIndexes:removedIndexes];
}

//- (void)updateItem:(SFObject *)object
//{
//    NSMutableArray *newItems = self.items.mutableCopy;
//    for (SFObject *item in self.items) {
//        if ([item isEqual:object]) {
//            NSInteger idx = [self.items indexOfObject:item];
//            newItems[idx] = object;
//        }
//    }
//    self.items = newItems;
//}
//
//- (void)removeItem:(SFObject *)object
//{
//    NSMutableArray *newItems = self.items.mutableCopy;
//    [newItems removeObject:object];
//    self.items = newItems;
//}

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:NO];
}

- (void)setItems:(NSArray *)items silenlty:(BOOL)silently
{
    if (!silently) {
        [self setItems:items animated:NO];
    } else if (items != _items) {
        _items = [items copy];
    }
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    if (!animated && items != _items) {
        _items = [items copy];
        [self notifyBatchUpdate:^{
            [self updateLoadingStateFromItems];
            [self notifySectionsRefreshed:[NSIndexSet indexSetWithIndex:0]];
        }];
        [self executePendingUpdates];
        return;
    }
    
    NSOrderedSet *oldItemSet = [NSOrderedSet orderedSetWithArray:_items];
    NSOrderedSet *newItemSet = [NSOrderedSet orderedSetWithArray:items];
    
    NSMutableOrderedSet *deletedItems = [oldItemSet mutableCopy];
    [deletedItems minusOrderedSet:newItemSet];
    
    NSMutableOrderedSet *newItems = [newItemSet mutableCopy];
    [newItems minusOrderedSet:oldItemSet];
    
    NSMutableOrderedSet *movedItems = [newItemSet mutableCopy];
    [movedItems intersectOrderedSet:oldItemSet];
    
    NSMutableArray *deletedIndexPaths = [NSMutableArray arrayWithCapacity:[deletedItems count]];
    for (id deletedItem in deletedItems) {
        [deletedIndexPaths addObject:[NSIndexPath indexPathForRow:[oldItemSet indexOfObject:deletedItem] inSection:0]];
    }
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray arrayWithCapacity:[newItems count]];
    for (id newItem in newItems) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:[newItemSet indexOfObject:newItem] inSection:0]];
    }
    
    NSMutableArray *fromMovedIndexPaths = [NSMutableArray arrayWithCapacity:[movedItems count]];
    NSMutableArray *toMovedIndexPaths = [NSMutableArray arrayWithCapacity:[movedItems count]];
    for (id movedItem in movedItems) {
        NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[oldItemSet indexOfObject:movedItem] inSection:0];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[newItemSet indexOfObject:movedItem] inSection:0];
        if (![fromIndexPath isEqual:toIndexPath]) {
            [fromMovedIndexPaths addObject:fromIndexPath];
            [toMovedIndexPaths addObject:toIndexPath];
        }
    }
    
    _items = [items copy];
    [self updateLoadingStateFromItems];
    
    if ([deletedIndexPaths count])
        [self notifyItemsRemovedAtIndexPaths:deletedIndexPaths];
    
    if ([insertedIndexPaths count])
        [self notifyItemsInsertedAtIndexPaths:insertedIndexPaths];
    
    NSUInteger count = [fromMovedIndexPaths count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *fromIndexPath = fromMovedIndexPaths[i];
        NSIndexPath *toIndexPath = toMovedIndexPaths[i];
        if (fromIndexPath != nil && toIndexPath != nil)
            [self notifyItemMovedFromIndexPath:fromIndexPath toIndexPaths:toIndexPath];
    }
}

- (void)updateLoadingStateFromItems
{
    NSString *loadingState = self.loadingState;
    NSUInteger numberOfItems = [_items count];
    if (numberOfItems && [loadingState isEqualToString:SFLoadStateNoContent])
        self.loadingState = SFLoadStateContentLoaded;
    else if (!numberOfItems && [loadingState isEqualToString:SFLoadStateContentLoaded])
        self.loadingState = SFLoadStateNoContent;
}

#pragma mark - KVC methods for item property

- (NSUInteger)countOfItems
{
    return [_items count];
}

- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes
{
    return [_items objectsAtIndexes:indexes];
}

- (void)getItems:(__unsafe_unretained id *)buffer range:(NSRange)range
{
    return [_items getObjects:buffer range:range];
}

- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes
{
    NSMutableArray *newItems = [_items mutableCopy];
    if (!newItems) {
        newItems = [NSMutableArray array];
    }
    [newItems insertObjects:array atIndexes:indexes];
    
    _items = newItems;
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray arrayWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    
    [self notifyBatchUpdate:^{
        [self updateLoadingStateFromItems];
        [self notifyItemsInsertedAtIndexPaths:insertedIndexPaths];
    }];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    NSInteger newCount = [_items count] - [indexes count];
    NSMutableArray *newItems = newCount > 0 ? [[NSMutableArray alloc] initWithCapacity:newCount] : nil;
    
    // set up a delayed set of batch update calls for later execution
    __block dispatch_block_t batchUpdates = ^{};
    batchUpdates = [batchUpdates copy];
    
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dispatch_block_t oldUpdates = batchUpdates;
        if ([indexes containsIndex:idx]) {
            // we're removing this item
            batchUpdates = ^{
                oldUpdates();
                [self notifyItemsRemovedAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
            };
        }
        else {
            // we're keeping this item
            NSUInteger newIdx = [newItems count];
            [newItems addObject:obj];
            batchUpdates = ^{
                oldUpdates();
                [self notifyItemMovedFromIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] toIndexPaths:[NSIndexPath indexPathForRow:newIdx inSection:0]];
            };
        }
        batchUpdates = [batchUpdates copy];
    }];
    
    _items = newItems;
    
    [self notifyBatchUpdate:^{
        batchUpdates();
        [self updateLoadingStateFromItems];
    }];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)array
{
    NSMutableArray *newItems = [_items mutableCopy];
    [newItems replaceObjectsAtIndexes:indexes withObjects:array];
    
    _items = newItems;
    
    NSMutableArray *replacedIndexPaths = [NSMutableArray arrayWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [replacedIndexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    
    [self notifyItemsRefreshedAtIndexPaths:replacedIndexPaths];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.obscuredByPlaceholder)
        return 1;
    
    return [_items count];
}



@end
