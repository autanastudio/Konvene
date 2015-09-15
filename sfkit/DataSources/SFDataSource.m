 //
//  SFDataSource.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 07/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"
#import "SFDataSource_Private.h"
#import <libkern/OSAtomic.h>
#import "SFExtensions.h"
#import "NSObject+KVOBlock.h"
#import "SFComposedDataSource_Private.h"

#define SF_ASSERT_MAIN_THREAD NSAssert([NSThread isMainThread], @"This method must be called on the main thread")

@interface SFDataSource () <SFStateMachineDelegate>
@property (nonatomic, strong) NSMutableDictionary *sectionMetrics;
@property (nonatomic, strong) NSMutableArray *headers;
@property (nonatomic, strong) NSMutableDictionary *headersByKey;
@property (nonatomic, strong) SFLoadableContentStateMachine *stateMachine;
@property (nonatomic, copy) dispatch_block_t pendingUpdateBlock;
@property (nonatomic, strong) UITableView *prototypeTableView;
@end

@implementation SFDataSource
@synthesize loadingError = _loadingError;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _adjustPlacholderHeightAutomatically = YES;
    }
    return self;
}

- (SFDataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex
{
    return self;
}

- (BOOL)isRootDataSource
{
    return self.parentDataSource == nil;
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath
{
    if (self.parentDataSource != nil) {
        return [self.parentDataSource localIndexPathForGlobalIndexPath:globalIndexPath dataSource:self];
    }
    return globalIndexPath;
}

- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath
{
    if (self.parentDataSource != nil) {
        return [self.parentDataSource globalIndexPathForLocalIndexPath:localIndexPath dataSource:self];
    }
    return localIndexPath;
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath dataSource:(SFDataSource *)dataSource
{
    return globalIndexPath;
}

- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath dataSource:(SFDataSource *)dataSource
{
    return localIndexPath;
}

- (NSArray *)indexPathsForItem:(id)object
{
    NSAssert(NO, @"Should be implemented by subclasses");
    return nil;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Should be implemented by subclasses");
    return nil;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Should be implemented by subclasses");
    return;
}

//- (void)updateItem:(SFObject *)object
//{
//    //Nothing to to do here...
//}
//
//- (void)removeItem:(SFObject *)object
//{
//    //Nothing to to do here...
//}


- (NSInteger)numberOfSections
{
    return 1;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    if (tableView != self.prototypeTableView) {
        self.prototypeTableView = [[UITableView alloc] init];
        [self registerReusableViewsWithTableView:self.prototypeTableView];
    }
}

- (UITableViewCell *)prototypeCellForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:self.prototypeTableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - SFContentLoading methods

- (SFLoadableContentStateMachine *)stateMachine
{
    if (_stateMachine)
        return _stateMachine;
    
    _stateMachine = [[SFLoadableContentStateMachine alloc] init];
    _stateMachine.delegate = self;
    return _stateMachine;
}

- (NSString *)loadingState
{
    // Don't cause the creation of the state machine just by inspection of the loading state.
    if (!_stateMachine)
        return SFLoadStateInitial;
    return _stateMachine.currentState;
}
 - (BOOL)loadingStateFinshed
 {
     NSString *loadingState = self.loadingState;
     return !([loadingState isEqualToString:SFLoadStateLoadingContent] ||
     [loadingState isEqualToString:SFLoadStateRefreshingContent] ||
     [loadingState isEqualToString:SFLoadStateInitial] ||
     [loadingState isEqualToString:SFLoadStateLoadingNextContent]);
 }

- (void)setLoadingState:(NSString *)loadingState
{
    SFLoadableContentStateMachine *stateMachine = self.stateMachine;
    if (loadingState != stateMachine.currentState)
        stateMachine.currentState = loadingState;
}

- (void)beginLoading
{
    self.loadingComplete = NO;
    self.loadingState = (([self.loadingState isEqualToString:SFLoadStateInitial] || [self.loadingState isEqualToString:SFLoadStateLoadingContent]) ? SFLoadStateLoadingContent : SFLoadStateRefreshingContent);
    
    [self notifyWillLoadContent];
}

- (void)endLoadingWithState:(NSString *)state error:(NSError *)error update:(dispatch_block_t)update
{
    self.loadingError = error;
    if ([self.loadingState isEqualToString:SFLoadStateLoadingNextContent] && error) {
        self.loadingState = SFLoadStateErrorNext;
    } else {
        self.loadingState = state;
    }
    
    if (self.shouldDisplayPlaceholder) {
        if (update)
            [self enqueuePendingUpdateBlock:update];
    }
    else {
        [self notifyBatchUpdate:^{
            // Run pending updates
            [self executePendingUpdates];
            if (update)
                update();
        }];
    }
    
    self.loadingComplete = YES;
    [self notifyContentLoadedWithError:error];
}

- (void)loadContentIfNeeded:(BOOL)forced
{
    if (forced || self.loadingState == SFLoadStateInitial) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadContent) object:nil];
        [self performSelector:@selector(loadContent) withObject:nil afterDelay:0];
    }
}

- (void)setNeedsLoadContentAfterDelay:(NSTimeInterval)delay
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadContent) object:nil];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:delay];
}

 - (void)setNeedLoadNextPage
 {
     //No implementation
 }

- (void)setNeedLoadSearchContentWithQuery:(NSString *)query
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(loadSearchContentWithQuery:) withObject:query afterDelay:.2];
}

- (void)loadSearchContentWithQuery:(NSString *)query
{
    // To be implemented by subclasses…
}

- (void)resetContent
{
    _stateMachine = nil;
    // Content has been reset, if we're loading something, chances are we don't need it.
    self.loadingInstance.current = NO;
}

- (void)loadContent
{
    // To be implemented by subclasses…
}

- (void)loadContentWithBlock:(SFLoadingBlock)block
{
    [self beginLoading];
    
    __weak typeof(&*self) weakself = self;
    
    SFLoading *loading = [SFLoading loadingWithCompletionHandler:^(NSString *newState, NSError *error, SFLoadingUpdateBlock update){
        if (!newState)
            return;
        
        [self endLoadingWithState:newState error:error update:^{
            SFDataSource *me = weakself;
            if (update && me)
                update(me);
        }];
    }];
    
    // Tell previous loading instance it's no longer current and remember this loading instance
    self.loadingInstance.current = NO;
    self.loadingInstance = loading;
    
    // Call the provided block to actually do the load
    block(loading);
}

- (void)whenLoaded:(dispatch_block_t)block
{
    __block int32_t complete = 0;
    
    [self sf_addObserverForKeyPath:sf_key(loadingComplete) options:NSKeyValueObservingOptionNew withBlock:^(id obj, NSDictionary *change, id observer) {
        BOOL loadingComplete = [change[NSKeyValueChangeNewKey] boolValue];
        if (!loadingComplete)
            return;
        
        [obj sf_removeObserver:observer];
        
        // Already called the completion handler
        if (!OSAtomicCompareAndSwap32(0, 1, &complete))
            return;
        
        block();
    }];
}

- (void)handleRowSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    //Should be implemented by subclasses;
}

- (void)stateWillChange
{
    // loadingState property isn't really Key Value Compliant, so let's begin a change notification
    [self willChangeValueForKey:@"loadingState"];
}

- (void)stateDidChange
{
    // loadingState property isn't really Key Value Compliant, so let's finish a change notification
    [self didChangeValueForKey:@"loadingState"];
}

- (void)didEnterLoadingState
{
    [self updatePlaceholder:self.placeholderView notifyVisibility:!self.loadingComplete];
}

- (void)didEnterLoadedState
{
    [self updatePlaceholder:self.placeholderView notifyVisibility:self.loadingComplete];
}

- (void)didEnterNoContentState
{
    [self updatePlaceholder:self.placeholderView notifyVisibility:self.loadingComplete];
}

- (void)didEnterErrorState
{
    [self updatePlaceholder:self.placeholderView notifyVisibility:self.loadingComplete];
}

#pragma mark - Placeholder

- (BOOL)obscuredByPlaceholder
{
    if (self.shouldDisplayPlaceholder)
        return YES;
    
    if (!self.delegate)
        return NO;
    
    if (![self.delegate isKindOfClass:[SFDataSource class]])
        return NO;
    
    SFDataSource *dataSource = (SFDataSource *)self.delegate;
    return dataSource.obscuredByPlaceholder;
}

- (BOOL)shouldDisplayPlaceholder
{
    NSString *loadingState = self.loadingState;
    
    // If we're in the error state & have an error message or title
    if ([loadingState isEqualToString:SFLoadStateError])
        return YES;
    
    // Only display a placeholder when we're loading or have no content
    if (![loadingState isEqualToString:SFLoadStateLoadingContent] && ![loadingState isEqualToString:SFLoadStateNoContent])
        return NO;
    
    return YES;
}

- (void)updatePlaceholder:(UITableViewCell<ISFPlaceholderCell> *)placeholderView notifyVisibility:(BOOL)notify
{
    if (placeholderView) {
        NSString *loadingState = self.loadingState;
        
        if ([loadingState isEqualToString:SFLoadStateLoadingContent]) {
            [placeholderView setPlaceholderState:SFPlaceholderStateLoading animated:YES];
        } else if ([loadingState isEqualToString:SFLoadStateNoContent]) {
            [placeholderView setPlaceholderState:SFPlaceholderStateNoContent animated:YES];
        } else if ([loadingState isEqualToString:SFLoadStateError]) {
            [placeholderView setPlaceholderState:SFPlaceholderStateError animated:YES];
        }
    }
    if (notify) {
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSections)];
        [self notifySectionsRefreshed:sections];
    }
}


- (UITableViewCell<ISFPlaceholderCell> *)dequeuePlaceholderViewForTableView:(UITableView *)tableView
                                                                atIndexPath:(NSIndexPath *)indexPath
{
    if (!self.placeholderView) {
        self.placeholderView = [[SFPlaceholderCell alloc] init];
    }
    if (self.adjustPlacholderHeightAutomatically) {
        CGFloat placholderHeight = tableView.height - tableView.contentInset.top - tableView.contentInset.bottom;
        self.placeholderView.preferedHeight = placholderHeight;
    }
    [self updatePlaceholder:_placeholderView notifyVisibility:NO];
    return _placeholderView;
}

#pragma mark - Notification methods

- (void)executePendingUpdates
{
    SF_ASSERT_MAIN_THREAD;
    dispatch_block_t block = _pendingUpdateBlock;
    _pendingUpdateBlock = nil;
    if (block)
        block();
}

- (void)enqueuePendingUpdateBlock:(dispatch_block_t)block
{
    dispatch_block_t update;
    
    if (_pendingUpdateBlock) {
        dispatch_block_t oldPendingUpdate = _pendingUpdateBlock;
        update = ^{
            oldPendingUpdate();
            block();
        };
    }
    else
        update = block;
    
    self.pendingUpdateBlock = update;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds)
        responds = [[self forwardingTargetForSelector:aSelector] respondsToSelector:aSelector];
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.delegate;
}

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths
{
    [self notifyItemsInsertedAtIndexPaths:insertedIndexPaths direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    if (self.shouldDisplayPlaceholder) {
        __weak typeof(&*self) weakself = self;
        [self enqueuePendingUpdateBlock:^{
            [weakself notifyItemsInsertedAtIndexPaths:insertedIndexPaths];
        }];
        return;
    }
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertItemsAtIndexPaths:direction:)]) {
        [delegate dataSource:self didInsertItemsAtIndexPaths:insertedIndexPaths direction:direction];
    }
}

- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths
{
    [self notifyItemsRemovedAtIndexPaths:removedIndexPaths direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    if (self.shouldDisplayPlaceholder) {
        __weak typeof(&*self) weakself = self;
        [self enqueuePendingUpdateBlock:^{
            [weakself notifyItemsRemovedAtIndexPaths:removedIndexPaths];
        }];
        return;
    }
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveItemsAtIndexPaths:direction:)]) {
        [delegate dataSource:self didRemoveItemsAtIndexPaths:removedIndexPaths direction:direction];
    }
}

- (void)notifyItemsRefreshedAtIndexPaths:(NSArray *)refreshedIndexPaths
{
    [self notifyItemsRefreshedAtIndexPaths:refreshedIndexPaths direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifyItemsRefreshedAtIndexPaths:(NSArray *)refreshedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    if (self.shouldDisplayPlaceholder) {
        __weak typeof(&*self) weakself = self;
        [self enqueuePendingUpdateBlock:^{
            [weakself notifyItemsRefreshedAtIndexPaths:refreshedIndexPaths];
        }];
        return;
    }
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRefreshItemsAtIndexPaths:direction:)]) {
        [delegate dataSource:self didRefreshItemsAtIndexPaths:refreshedIndexPaths direction:direction];
    }
}

- (void)notifyItemMovedFromIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSIndexPath *)newIndexPath
{
    SF_ASSERT_MAIN_THREAD;
    if (self.shouldDisplayPlaceholder) {
        __weak typeof(&*self) weakself = self;
        [self enqueuePendingUpdateBlock:^{
            [weakself notifyItemMovedFromIndexPath:indexPath toIndexPaths:newIndexPath];
        }];
        return;
    }
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didMoveItemAtIndexPath:toIndexPath:)]) {
        [delegate dataSource:self didMoveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

- (void)notifySectionsInserted:(NSIndexSet *)sections
{
    [self notifySectionsInserted:sections direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifySectionsInserted:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertSections:direction:)]) {
        [delegate dataSource:self didInsertSections:sections direction:direction];
    }
}

- (void)notifySectionsRemoved:(NSIndexSet *)sections
{
    [self notifySectionsRemoved:sections direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifySectionsRemoved:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveSections:direction:)]) {
        [delegate dataSource:self didRemoveSections:sections direction:direction];
    }
}


- (void)notifySectionsRefreshed:(NSIndexSet *)sections
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRefreshSections:)]) {
        [delegate dataSource:self didRefreshSections:sections];
    }
}

- (void)notifySectionMovedFrom:(NSInteger)section to:(NSInteger)newSection
{
    [self notifySectionMovedFrom:section to:newSection direction:SFDataSourceSectionOperationDirectionNone];
}

- (void)notifySectionMovedFrom:(NSInteger)section to:(NSInteger)newSection direction:(SFDataSourceSectionOperationDirection)direction
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didMoveSection:toSection:direction:)]) {
        [delegate dataSource:self didMoveSection:section toSection:newSection direction:direction];
    }
}

- (void)notifyDidReloadData
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceDidReloadData:)]) {
        [delegate dataSourceDidReloadData:self];
    }
}

- (void)notifyBatchUpdate:(dispatch_block_t)update
{
    [self notifyBatchUpdate:update complete:nil];
}

- (void)notifyBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete
{
    SF_ASSERT_MAIN_THREAD;
    
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:performBatchUpdate:complete:)]) {
        [delegate dataSource:self performBatchUpdate:update complete:complete];
    }
    else {
        if (update) {
            update();
        }
        if (complete) {
            complete();
        }
    }
}

- (void)notifyContentLoadedWithError:(NSError *)error
{
    SF_ASSERT_MAIN_THREAD;
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didLoadContentWithError:)]) {
        [delegate dataSource:self didLoadContentWithError:error];
    }
}

- (void)notifyWillLoadContent
{
    SF_ASSERT_MAIN_THREAD;
    id<SFDataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceWillLoadContent:)]) {
        [delegate dataSourceWillLoadContent:self];
    }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Should be implemented by subclasses");
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView
        moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
               toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Should be implemented by subclasses.
}

@end
