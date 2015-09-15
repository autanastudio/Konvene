//
//  SFSegmentedDataSource.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFSegmentedDataSource.h"
#import "SFDataSource_Private.h"

@implementation UISegmentedControl (SFDataSourceAddition)
@end

@interface SFSegmentedDataSource () <SFDataSourceDelegate>
@property (nonatomic, strong) NSMutableArray *mutableDataSources;
@end

@implementation SFSegmentedDataSource
@synthesize mutableDataSources = _dataSources;
@synthesize selectedDataSource = _selectedDataSource;

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _dataSources = [[NSMutableArray alloc] init];
    return self;
}

- (NSInteger)numberOfSections
{
    return _selectedDataSource.numberOfSections;
}

- (SFDataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex
{
    return [_selectedDataSource dataSourceForSectionAtIndex:sectionIndex];
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath
{
    return [_selectedDataSource localIndexPathForGlobalIndexPath:globalIndexPath];
}

- (NSArray *)dataSources
{
    return [NSArray arrayWithArray:_dataSources];
}

- (void)addDataSource:(SFDataSource *)dataSource
{
    if (![self.dataSources count]) {
        _selectedDataSource = dataSource;
    }
    [_dataSources addObject:dataSource];
    dataSource.delegate = self;
    dataSource.parentDataSource = self;
}

- (void)removeDataSource:(SFDataSource *)dataSource
{
    [_dataSources removeObject:dataSource];
    if (dataSource.delegate == self) {
        dataSource.delegate = nil;
        dataSource.parentDataSource = nil;
    }
}

- (void)insertDataSource:(SFDataSource *)dataSource atIndex:(NSInteger)index
{
    if (![self.dataSources count]) {
        _selectedDataSource = dataSource;
    }
    [_dataSources insertObject:dataSource atIndex:index];
    dataSource.delegate = self;
    dataSource.parentDataSource = self;
}

- (void)removeAllDataSources
{
    for (SFDataSource *dataSource in _dataSources) {
        if (dataSource.delegate == self) {
            dataSource.delegate = nil;
            dataSource.parentDataSource = nil;
        }
    }
    
    _dataSources = [NSMutableArray array];
    _selectedDataSource = nil;
}

- (SFDataSource *)dataSourceAtIndex:(NSInteger)dataSourceIndex
{
    return _dataSources[dataSourceIndex];
}

- (NSInteger)selectedDataSourceIndex
{
    return [_dataSources indexOfObject:_selectedDataSource];
}

- (void)setSelectedDataSourceIndex:(NSInteger)selectedDataSourceIndex
{
    [self setSelectedDataSourceIndex:selectedDataSourceIndex animated:NO];
}

- (void)setSelectedDataSourceIndex:(NSInteger)selectedDataSourceIndex animated:(BOOL)animated
{
    SFDataSource *dataSource = [_dataSources objectAtIndex:selectedDataSourceIndex];
    [self setSelectedDataSource:dataSource animated:animated completionHandler:nil];
}

- (void)setSelectedDataSource:(SFDataSource *)selectedDataSource
{
    [self setSelectedDataSource:selectedDataSource animated:NO completionHandler:nil];
}

- (void)setSelectedDataSource:(SFDataSource *)selectedDataSource animated:(BOOL)animated
{
    [self setSelectedDataSource:selectedDataSource animated:animated completionHandler:nil];
}

- (void)setSelectedDataSource:(SFDataSource *)selectedDataSource animated:(BOOL)animated completionHandler:(dispatch_block_t)handler
{
    if (_selectedDataSource == selectedDataSource) {
        if (handler)
            handler();
        return;
    }
    
    [self willChangeValueForKey:@"selectedDataSource"];
    [self willChangeValueForKey:@"selectedDataSourceIndex"];
    NSAssert([_dataSources containsObject:selectedDataSource], @"selected data source must be contained in this data source");
    
    SFDataSource *oldDataSource = _selectedDataSource;
    NSInteger numberOfOldSections = oldDataSource.numberOfSections;
    NSInteger numberOfNewSections = selectedDataSource.numberOfSections;
    
    SFDataSourceSectionOperationDirection direction = SFDataSourceSectionOperationDirectionNone;
    
    if (animated) {
        NSInteger oldIndex = [_dataSources indexOfObjectIdenticalTo:oldDataSource];
        NSInteger newIndex = [_dataSources indexOfObjectIdenticalTo:selectedDataSource];
        direction = (oldIndex < newIndex) ? SFDataSourceSectionOperationDirectionRight : SFDataSourceSectionOperationDirectionLeft;
    }
    
    NSIndexSet *removedSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfOldSections)];;
    NSIndexSet *insertedSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfNewSections)];
    
    _selectedDataSource = selectedDataSource;
    
    [self didChangeValueForKey:@"selectedDataSource"];
    [self didChangeValueForKey:@"selectedDataSourceIndex"];
    
    // Update the sections all at once.
    
    void (^selectionBlock)() = ^{
        [self notifyBatchUpdate:^{
            if (removedSet)
                [self notifySectionsRemoved:removedSet direction:direction];
            if (insertedSet)
                [self notifySectionsInserted:insertedSet direction:direction];
        } complete:handler];
    };
    
    if (self.animateDataSourceSelection) {
        selectionBlock();
    } else {
        [UIView performWithoutAnimation:selectionBlock];
    }
    
    // If the newly selected data source has never been loaded, load it now
    [selectedDataSource loadContentIfNeeded:NO];
}

- (NSArray *)indexPathsForItem:(id)object
{
    return [_selectedDataSource indexPathsForItem:object];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_selectedDataSource itemAtIndexPath:indexPath];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_selectedDataSource removeItemAtIndexPath:indexPath];
}


//- (void)updateItem:(SFObject *)object
//{
//    for (SFDataSource *dataSource in self.dataSources) {
//        [dataSource updateItem:object];
//    }
//}
//
//- (void)removeItem:(SFObject *)object
//{
//    for (SFDataSource * dataSource in self.dataSources) {
//        [dataSource removeItem:object];
//    }
//}


- (void)configureSegmentedControl:(id<ISFSegmentedControl>)segmentedControl
{
    NSArray *titles = [self.dataSources valueForKey:@"title"];
    
    [segmentedControl removeAllSegments];
    [titles enumerateObjectsUsingBlock:^(NSString *segmentTitle, NSUInteger segmentIndex, BOOL *stop) {
        if ([segmentTitle isEqual:[NSNull null]])
            segmentTitle = @"NULL";
        [segmentedControl insertSegmentWithTitle:segmentTitle atIndex:segmentIndex animated:NO];
    }];
    [segmentedControl addTarget:self action:@selector(selectedSegmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = self.selectedDataSourceIndex;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    for (SFDataSource *dataSource in self.dataSources)
        [dataSource registerReusableViewsWithTableView:tableView];
}


#pragma mark - AAPLContentLoading

- (NSString *)loadingState
{
    return self.selectedDataSource.loadingState;
}

- (void)loadContent
{
    // Only load the currently selected data source. Others will be loaded as necessary.
    [_selectedDataSource loadContent];
}

- (void)loadSearchContentWithQuery:(NSString *)query
{
    [_selectedDataSource loadSearchContentWithQuery:query];
}

- (void)resetContent
{
    for (SFDataSource *dataSource in self.dataSources)
        [dataSource resetContent];
    [super resetContent];
}

- (void)handleRowSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedDataSource handleRowSelectionAtIndexPath:indexPath];
}

- (void)setNeedLoadNextPage
{
    [self.selectedDataSource setNeedLoadNextPage];
}

#pragma mark - Header action method

- (void)selectedSegmentIndexChanged:(id)sender
{
    id<ISFSegmentedControl> segmentedControl = (id<ISFSegmentedControl>)sender;
    if (![segmentedControl conformsToProtocol:@protocol(ISFSegmentedControl)])
        return;
    
    segmentedControl.userInteractionEnabled = NO;
    NSInteger selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    SFDataSource *dataSource = self.dataSources[selectedSegmentIndex];
    [self setSelectedDataSource:dataSource animated:NO completionHandler:^{
        segmentedControl.userInteractionEnabled = YES;
    }];
}

#pragma mark - Placeholders

- (BOOL)shouldDisplayPlaceholder
{
    if ([super shouldDisplayPlaceholder])
        return YES;
    
    NSString *loadingState = _selectedDataSource.loadingState;
    
    // If we're in the error state & have an error message or title
    if ([loadingState isEqualToString:SFLoadStateError])
        return YES;
    
    // Only display a placeholder when we're loading or have no content
    if (![loadingState isEqualToString:SFLoadStateLoadingContent] && ![loadingState isEqualToString:SFLoadStateNoContent])
        return NO;
    
    return YES;
}

#pragma mark - UiTablewViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectedDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_selectedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.selectedDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.selectedDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.selectedDataSource tableView:tableView
                    moveRowAtIndexPath:sourceIndexPath
                           toIndexPath:destinationIndexPath];
}

#pragma mark - SFDataSourceDelegate methods

- (void)dataSource:(SFDataSource *)dataSource
    didInsertItemsAtIndexPaths:(NSArray *)indexPaths
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if (dataSource != _selectedDataSource) {
        return;
    }
    [self notifyItemsInsertedAtIndexPaths:indexPaths direction:direction];
}

- (void)dataSource:(SFDataSource *)dataSource
    didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if (dataSource != _selectedDataSource) {
        return;
    }
    [self notifyItemsRemovedAtIndexPaths:indexPaths direction:direction];
}

- (void)dataSource:(SFDataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyItemsInsertedAtIndexPaths:indexPaths];
}

- (void)dataSource:(SFDataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyItemsRemovedAtIndexPaths:indexPaths];
}

- (void)dataSource:(SFDataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray *)indexPaths
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyItemsRefreshedAtIndexPaths:indexPaths];
}

- (void)dataSource:(SFDataSource *)dataSource didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyItemMovedFromIndexPath:fromIndexPath toIndexPaths:newIndexPath];
}

- (void)dataSource:(SFDataSource *)dataSource didInsertSections:(NSIndexSet *)sections
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifySectionsInserted:sections];
}

- (void)dataSource:(SFDataSource *)dataSource didRemoveSections:(NSIndexSet *)sections
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifySectionsRemoved:sections];
}

- (void)dataSource:(SFDataSource *)dataSource didRefreshSections:(NSIndexSet *)sections
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifySectionsRefreshed:sections];
}

- (void)dataSource:(SFDataSource *)dataSource didMoveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifySectionMovedFrom:section to:newSection];
}

- (void)dataSourceDidReloadData:(SFDataSource *)dataSource
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyDidReloadData];
}

- (void)dataSource:(SFDataSource *)dataSource performBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete
{
    if (dataSource != _selectedDataSource) {
        if (update)
            update();
        if (complete)
            complete();
        return;
    }
    
    [self notifyBatchUpdate:update complete:complete];
}

- (void)dataSource:(SFDataSource *)dataSource didLoadContentWithError:(NSError *)error
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyContentLoadedWithError:error];
}

- (void)dataSourceWillLoadContent:(SFDataSource *)dataSource
{
    if (dataSource != _selectedDataSource)
        return;
    
    [self notifyWillLoadContent];
}

@end
