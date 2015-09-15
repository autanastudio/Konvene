//
//  SFComposedDataSource.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFComposedDataSource.h"
#import "SFComposedDataSource_Private.h"
#import "SFDataSource_Private.h"

@interface SFComposedDataSource () <SFDataSourceDelegate>
@property(nonatomic, retain) NSMutableArray *mappings;
@property(nonatomic, retain) NSMapTable *dataSourceToMappings;
@property(nonatomic, retain) NSMutableDictionary *globalSectionToMappings;
@property(nonatomic, assign) NSUInteger sectionCount;
@property(nonatomic, readonly) NSArray *dataSources;
@property(nonatomic, strong) NSString *aggregateLoadingState;
@end

@implementation SFComposedDataSource

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _mappings = [[NSMutableArray alloc] init];
    _dataSourceToMappings =
            [[NSMapTable alloc]
                         initWithKeyOptions:NSMapTableObjectPointerPersonality
                               valueOptions:NSMapTableStrongMemory
                                   capacity:1];
    _globalSectionToMappings = [[NSMutableDictionary alloc] init];

    return self;
}

- (id)wrapperForView:(UICollectionView *)collectionView mapping:(SFComposedMapping *)mapping
{
    return [SFComposedViewWrapper wrapperForView:collectionView mapping:mapping];
}

- (void)updateMappings
{
    _sectionCount = 0;
    [_globalSectionToMappings removeAllObjects];

    for (SFComposedMapping *mapping in _mappings) {
        NSUInteger newSectionCount = [mapping updateMappingsStartingWithGlobalSection:_sectionCount];
        while (_sectionCount < newSectionCount) {
            _globalSectionToMappings[@(_sectionCount++)] = mapping;
        }
    }
}

- (NSUInteger)sectionForDataSource:(SFDataSource *)dataSource
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];

    return [mapping globalSectionForLocalSection:0];
}

- (SFDataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex
{
    SFComposedMapping *mapping = _globalSectionToMappings[@(sectionIndex)];
    return mapping.dataSource;
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:globalIndexPath.section];
    return [mapping localIndexPathForGlobalIndexPath:globalIndexPath];
}

- (SFComposedMapping *)mappingForGlobalSection:(NSInteger)section
{
    SFComposedMapping *mapping = _globalSectionToMappings[@(section)];
    return mapping;
}

- (SFComposedMapping *)mappingForDataSource:(SFDataSource *)dataSource
{
    SFComposedMapping *mapping = [_dataSourceToMappings objectForKey:dataSource];
    return mapping;
}

- (NSIndexSet *)globalSectionsForLocal:(NSIndexSet *)localSections dataSource:(SFDataSource *)dataSource
{
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    [localSections enumerateIndexesUsingBlock:^(NSUInteger localSection, BOOL *stop) {
        [result addIndex:[mapping globalSectionForLocalSection:localSection]];
    }];
    return result;
}

- (NSArray *)globalIndexPathsForLocal:(NSArray *)localIndexPaths dataSource:(SFDataSource *)dataSource
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[localIndexPaths count]];
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    for (NSIndexPath *localIndexPath in localIndexPaths) {
        [result addObject:[mapping globalIndexPathForLocalIndexPath:localIndexPath]];
    }

    return result;
}

- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath dataSource:(SFDataSource *)dataSource
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    return [mapping globalIndexPathForLocalIndexPath:localIndexPath];
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath dataSource:(SFDataSource *)dataSource
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    return [mapping localIndexPathForGlobalIndexPath:globalIndexPath];
}

- (NSArray *)dataSources
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[_dataSourceToMappings count]];
    for (id key in _dataSourceToMappings) {
        SFComposedMapping *mapping = [_dataSourceToMappings objectForKey:key];
        [result addObject:mapping.dataSource];
    }
    return result;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];

    NSIndexPath *mappedIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [mapping.dataSource itemAtIndexPath:mappedIndexPath];
}

- (NSArray *)indexPathsForItem:(id)object
{
    NSMutableArray *results = [NSMutableArray array];
    NSArray *dataSources = self.dataSources;

    for (SFDataSource *dataSource in dataSources) {
        SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
        NSArray *indexPaths = [dataSource indexPathsForItem:object];

        if (![indexPaths count]) {
            continue;
        }

        for (NSIndexPath *localIndexPath in indexPaths) {
            [results addObject:[mapping globalIndexPathForLocalIndexPath:localIndexPath]];
        }
    }

    return results;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    [dataSource removeItemAtIndexPath:localIndexPath];
}

//
//- (void)updateItem:(SFObject *)object
//{
//    for (SFDataSource *dataSource in self.dataSources) {
//        [dataSource updateItem:object];
//    }
//}
//
//- (void)removeItem:(SFObject *)object
//{
//    for (SFDataSource *dataSource in self.dataSources) {
//        [dataSource removeItem:object];
//    }
//}


#pragma mark - SFComposedDataSource API

- (void)addDataSource:(SFDataSource *)dataSource
{
    NSParameterAssert(dataSource != nil);

    dataSource.delegate = self;

    SFComposedMapping *mappingForDataSource = [_dataSourceToMappings objectForKey:dataSource];
    NSAssert(mappingForDataSource == nil, @"tried to add data source more than once: %@", dataSource);

    mappingForDataSource = [[SFComposedMapping alloc] initWithDataSource:dataSource];
    [_mappings addObject:mappingForDataSource];
    [_dataSourceToMappings setObject:mappingForDataSource forKey:dataSource];

    [self updateMappings];
    NSMutableIndexSet *addedSections = [NSMutableIndexSet indexSet];
    NSUInteger numberOfSections = dataSource.numberOfSections;

    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx) {
        [addedSections addIndex:[mappingForDataSource globalSectionForLocalSection:sectionIdx]];
    }
}

- (void)removeDataSource:(SFDataSource *)dataSource
{
    SFComposedMapping *mappingForDataSource = [_dataSourceToMappings objectForKey:dataSource];
    NSAssert(mappingForDataSource != nil, @"Data source not found in mapping");

    NSMutableIndexSet *removedSections = [NSMutableIndexSet indexSet];
    NSUInteger numberOfSections = dataSource.numberOfSections;

    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx) {
        [removedSections addIndex:[mappingForDataSource globalSectionForLocalSection:sectionIdx]];
    }

    [_dataSourceToMappings removeObjectForKey:dataSource];
    [_mappings removeObject:mappingForDataSource];

    dataSource.delegate = nil;

    [self updateMappings];
}

#pragma mark - SFDataSource methods

- (NSInteger)numberOfSections
{
    [self updateMappings];
    return _sectionCount;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    for (SFDataSource *dataSource in self.dataSources) {
        [dataSource registerReusableViewsWithTableView:tableView];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:mapping];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [dataSource tableView:wrapper canEditRowAtIndexPath:localIndexPath];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:mapping];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [dataSource tableView:wrapper commitEditingStyle:editingStyle forRowAtIndexPath:localIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:mapping];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [dataSource tableView:wrapper canMoveRowAtIndexPath:localIndexPath];
}

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // This is a bit simplistic: basically, if the move is between data sources, I'm going to assume the answer is NO. Subclasses can improve upon this if desired.
    SFComposedMapping *fromMapping = [self mappingForGlobalSection:sourceIndexPath.section];
    SFComposedMapping *toMapping = [self mappingForGlobalSection:destinationIndexPath.section];

    if (toMapping != fromMapping) {
        return;
    }

    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:fromMapping];
    SFDataSource *dataSource = fromMapping.dataSource;

    NSIndexPath *localFromIndexPath = [fromMapping localIndexPathForGlobalIndexPath:sourceIndexPath];
    NSIndexPath *localToIndexPath = [fromMapping localIndexPathForGlobalIndexPath:destinationIndexPath];

    [dataSource tableView:wrapper moveRowAtIndexPath:localFromIndexPath toIndexPath:localToIndexPath];
}

#pragma mark - SFContentLoading

- (void)updateLoadingState
{
    // let's find out what our state should be by asking our data sources
    NSInteger numberOfLoading = 0;
    NSInteger numberOfRefreshing = 0;
    NSInteger numberOfError = 0;
    NSInteger numberOfLoaded = 0;
    NSInteger numberOfNoContent = 0;
    NSInteger numberOfInitial = 0;
    NSInteger numberOfLoadingNext = 0;
    NSInteger numberOfErrorNext = 0;

    NSArray *loadingStates = [self.dataSources valueForKey:@"loadingState"];

    for (NSString *state in loadingStates) {
        if ([state isEqualToString:SFLoadStateLoadingContent]) {
            numberOfLoading++;
        } else if ([state isEqualToString:SFLoadStateRefreshingContent]) {
            numberOfRefreshing++;
        } else if ([state isEqualToString:SFLoadStateError]) {
            numberOfError++;
        } else if ([state isEqualToString:SFLoadStateContentLoaded]) {
            numberOfLoaded++;
        } else if ([state isEqualToString:SFLoadStateNoContent]) {
            numberOfNoContent++;
        } else if ([state isEqualToString:SFLoadStateInitial]) {
            numberOfInitial++;
        } else if ([state isEqualToString:SFLoadStateLoadingNextContent]) {
            numberOfLoadingNext++;
        } else if ([state isEqualToString:SFLoadStateErrorNext]) {
            numberOfErrorNext++;
        }
    }

/*    NSLog(@"Composed.loadingState: loading = %d  refreshing = %d  error = %d  no content = %d  loaded = %d",
          numberOfLoading,
          numberOfRefreshing,
          numberOfError,
          numberOfNoContent,
          numberOfLoaded);*/

    // Always prefer loading
    if (numberOfLoading) {
        _aggregateLoadingState = SFLoadStateLoadingContent;
    } else if (numberOfRefreshing) {
        _aggregateLoadingState = SFLoadStateRefreshingContent;
    } else if (numberOfError) {
        _aggregateLoadingState = SFLoadStateError;
    } else if (numberOfNoContent) {
        _aggregateLoadingState = SFLoadStateNoContent;
    } else if (numberOfInitial) {
        _aggregateLoadingState = SFLoadStateInitial;
    } else if (numberOfLoadingNext) {
        _aggregateLoadingState = SFLoadStateLoadingNextContent;
    } else if (numberOfErrorNext) {
        _aggregateLoadingState = SFLoadStateErrorNext;
    } else {
        _aggregateLoadingState = SFLoadStateContentLoaded;
    }
}

- (NSString *)loadingState
{
    if (!_aggregateLoadingState) {
        [self updateLoadingState];
    }
    return _aggregateLoadingState;
}

- (BOOL)loadingStateFinished
{
    for (SFDataSource *dataSource in self.dataSources) {
        if (!dataSource.loadingStateFinshed) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)loadingComplete
{
    for (SFDataSource *dataSource in self.dataSources) {
        if (!dataSource.loadingComplete) {
            return NO;
        }
    }
    return YES;
}

- (void)setLoadingState:(NSString *)loadingState
{
    _aggregateLoadingState = nil;
    [super setLoadingState:loadingState];
}

- (void)setNeedLoadNextPage
{
    SFDataSource *lastDataSource = [self dataSourceForSectionAtIndex:self.numberOfSections - 1];
    [lastDataSource setNeedLoadNextPage];
}

- (void)loadContent
{
    for (SFDataSource *dataSource in self.dataSources) {
        [dataSource loadContent];
    }
}

- (void)resetContent
{
    _aggregateLoadingState = nil;
    [super resetContent];
    for (SFDataSource *dataSource in self.dataSources) {
        [dataSource resetContent];
    }
}

- (void)handleRowSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [dataSource handleRowSelectionAtIndexPath:localIndexPath];
}

- (void)stateDidChange
{
    [super stateDidChange];
    [self updateLoadingState];
}


- (BOOL)shouldDisplayPlaceholder
{
    return NO;
}

- (BOOL)obscuredByPlaceholder
{
    return NO;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateMappings];

    SFComposedMapping *mapping = [self mappingForGlobalSection:section];
    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:mapping];
    NSInteger localSection = [mapping localSectionForGlobalSection:section];
    SFDataSource *dataSource = mapping.dataSource;

    NSInteger numberOfSections = [dataSource numberOfSectionsInTableView:wrapper];
    NSAssert(localSection < numberOfSections, @"local section is out of bounds for composed data source");

    // If we're showing the placeholder, ignore what the child data sources have to say about the number of items.
    if (self.obscuredByPlaceholder) {
        return 0;
    }

    NSInteger count = [dataSource tableView:wrapper numberOfRowsInSection:localSection];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFComposedMapping *mapping = [self mappingForGlobalSection:indexPath.section];
    UITableView *wrapper = [SFComposedViewWrapper wrapperForView:tableView mapping:mapping];
    SFDataSource *dataSource = mapping.dataSource;
    NSIndexPath *localIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];

    return [dataSource tableView:wrapper cellForRowAtIndexPath:localIndexPath];
}

#pragma mark - SFDataSourceDelegate

- (void)        dataSource:(SFDataSource *)dataSource
didInsertItemsAtIndexPaths:(NSArray *)indexPaths
                 direction:(SFDataSourceSectionOperationDirection)direction
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];

    [self notifyItemsInsertedAtIndexPaths:globalIndexPaths direction:direction];
}

- (void)        dataSource:(SFDataSource *)dataSource
didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
                 direction:(SFDataSourceSectionOperationDirection)direction
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];

    [self notifyItemsRemovedAtIndexPaths:globalIndexPaths direction:direction];
}

- (void)dataSource:(SFDataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];

    [self notifyItemsInsertedAtIndexPaths:globalIndexPaths];
}

- (void)dataSource:(SFDataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];

    [self notifyItemsRemovedAtIndexPaths:globalIndexPaths];
}

- (void)dataSource:(SFDataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray *)indexPaths
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];

    [self notifyItemsRefreshedAtIndexPaths:globalIndexPaths];
}

- (void)    dataSource:(SFDataSource *)dataSource
didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)newIndexPath
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSIndexPath *globalFromIndexPath = [mapping globalIndexPathForLocalIndexPath:fromIndexPath];
    NSIndexPath *globalNewIndexPath = [mapping globalIndexPathForLocalIndexPath:newIndexPath];

    [self notifyItemMovedFromIndexPath:globalFromIndexPath toIndexPaths:globalNewIndexPath];
}

- (void)dataSource:(SFDataSource *)dataSource
 didInsertSections:(NSIndexSet *)sections
         direction:(SFDataSourceSectionOperationDirection)direction
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];

    [self updateMappings];

    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];

    [self notifySectionsInserted:globalSections direction:direction];
}

- (void)dataSource:(SFDataSource *)dataSource
 didRemoveSections:(NSIndexSet *)sections
         direction:(SFDataSourceSectionOperationDirection)direction
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];

    [self updateMappings];

    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];

    [self notifySectionsRemoved:globalSections direction:direction];
}

- (void)dataSource:(SFDataSource *)dataSource didRefreshSections:(NSIndexSet *)sections
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];

    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];

    [self notifySectionsRefreshed:globalSections];
    [self updateMappings];
}

- (void)dataSource:(SFDataSource *)dataSource
    didMoveSection:(NSInteger)section
         toSection:(NSInteger)newSection
         direction:(SFDataSourceSectionOperationDirection)direction
{
    SFComposedMapping *mapping = [self mappingForDataSource:dataSource];

    NSInteger globalSection = [mapping globalSectionForLocalSection:section];
    NSInteger globalNewSection = [mapping globalSectionForLocalSection:newSection];

    [self updateMappings];

    [self notifySectionMovedFrom:globalSection to:globalNewSection direction:direction];
}

- (void)dataSourceDidReloadData:(SFDataSource *)dataSource
{
    [self notifyDidReloadData];
}

- (void)dataSource:(SFDataSource *)dataSource
performBatchUpdate:(dispatch_block_t)update
          complete:(dispatch_block_t)complete
{
    if (self.loadingStateFinished) {
        [self notifyBatchUpdate:^{
            [self executePendingUpdates];
            if (update) {
                update();
            }
        }              complete:complete];
    } else {
        [self enqueuePendingUpdateBlock:^{
            if (update) {
                update();
            }
        }];
    }
}

/// If the content was loaded successfully, the error will be nil.
- (void)dataSource:(SFDataSource *)dataSource didLoadContentWithError:(NSError *)error
{
    BOOL showingPlaceholder = self.shouldDisplayPlaceholder;
    [self updateLoadingState];

    // We were showing the placehoder and now we're not
    if (showingPlaceholder && !self.shouldDisplayPlaceholder) {
        [UIView performWithoutAnimation:^{
            [self notifyBatchUpdate:^{
                [self executePendingUpdates];
            }];
        }];
    }
    if (self.loadingStateFinished) {
        [self notifyContentLoadedWithError:error];
    }
}

/// Called just before a datasource begins loading its content.
- (void)dataSourceWillLoadContent:(SFDataSource *)dataSource
{
    [self updateLoadingState];
    [self notifyWillLoadContent];
}
@end