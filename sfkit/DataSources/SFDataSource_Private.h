//
//  SFDataSource_Private.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 07/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"
#import "SFPlaceholderCell.h"

typedef NS_ENUM(NSInteger, SFDataSourceSectionOperationDirection) {
    SFDataSourceSectionOperationDirectionNone = 0,
    SFDataSourceSectionOperationDirectionLeft,
    SFDataSourceSectionOperationDirectionRight,
};


@interface SFDataSource ()
- (UITableViewCell<ISFPlaceholderCell> *)dequeuePlaceholderViewForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

- (void)beginLoading;
- (void)endLoadingWithState:(NSString *)state error:(NSError *)error update:(dispatch_block_t)update;
@property (nonatomic) BOOL loadingComplete;
@property (nonatomic, weak) SFLoading *loadingInstance;

- (void)updatePlaceholder:(UITableViewCell<ISFPlaceholderCell> *)placeholderView notifyVisibility:(BOOL)notify;

- (void)stateWillChange;
- (void)stateDidChange;

- (void)enqueuePendingUpdateBlock:(dispatch_block_t)block;
- (void)executePendingUpdates;

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction;
- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction;
- (void)notifyItemsRefreshedAtIndexPaths:(NSArray *)refreshedIndexPaths direction:(SFDataSourceSectionOperationDirection)direction;

- (void)notifySectionsInserted:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction;
- (void)notifySectionsRemoved:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction;
- (void)notifySectionMovedFrom:(NSInteger)section to:(NSInteger)newSection direction:(SFDataSourceSectionOperationDirection)direction;

/// Is this data source the root data source? This depends on proper set up of the delegate property. Container data sources ALWAYS act as the delegate for their contained data sources.
@property (nonatomic, readonly, getter = isRootDataSource) BOOL rootDataSource;

@property (nonatomic, weak) SFDataSource *parentDataSource;

/// Whether this data source should display the placeholder.
@property (nonatomic, readonly) BOOL shouldDisplayPlaceholder;


/// A delegate object that will receive change notifications from this data source.
@property (nonatomic, weak) id<SFDataSourceDelegate> delegate;

//IndexPaths mapping

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath dataSource:(SFDataSource *)dataSource;
- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath dataSource:(SFDataSource *)dataSource;

@end

@protocol SFDataSourceDelegate <NSObject>
@optional

- (void)dataSource:(SFDataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray *)indexPaths direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (void)dataSource:(SFDataSource *)dataSource didInsertSections:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didRemoveSections:(NSIndexSet *)sections direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didMoveSection:(NSInteger)section toSection:(NSInteger)newSection direction:(SFDataSourceSectionOperationDirection)direction;
- (void)dataSource:(SFDataSource *)dataSource didRefreshSections:(NSIndexSet *)sections;
- (void)dataSourceDidReloadData:(SFDataSource *)dataSource;
- (void)dataSource:(SFDataSource *)dataSource performBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete;

/// If the content was loaded successfully, the error will be nil.
- (void)dataSource:(SFDataSource *)dataSource didLoadContentWithError:(NSError *)error;

/// Called just before a datasource begins loading its content.
- (void)dataSourceWillLoadContent:(SFDataSource *)dataSource;
@end

