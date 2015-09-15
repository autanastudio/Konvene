//
//  SFDataSource.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 07/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentLoading.h"
#import "ISFModalMessageView.h"
#import "SFPlaceholderCell.h"

@protocol SFDataSourceDelegate;
@interface SFDataSource : NSObject <UITableViewDataSource, SFContentLoading>

/// The title of this data source. This value is used to populate section headers and the segmented control tab.
@property (nonatomic, copy) NSString *title;
/// The number of sections in this data source.
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, assign) Class<ISFModalMessageView> errorModalMessageClass;

/// Find the data source for the given section. Default implementation returns self.
- (SFDataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex;

/// Find the item at the specified index path.
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath;

- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath;

/// Find the index paths of the specified item in the data source. An item may appear more than once in a given data source.
- (NSArray*)indexPathsForItem:(id)item;

/// Remove an item from the data source. This method should only be called as the result of a user action, such as tapping the "Delete" button in a swipe-to-delete gesture. Automatic removal of items due to outside changes should instead be handled by the data source itself — not the controller. Data sources must implement this to support swipe-to-delete.
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;

//- (void)updateItem:(SFObject *)object;
//- (void)removeItem:(SFObject *)object;

// Use these methods to notify the collection view of changes to the dataSource.
- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths;
- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths;
- (void)notifyItemsRefreshedAtIndexPaths:(NSArray *)refreshedIndexPaths;
- (void)notifyItemMovedFromIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSIndexPath *)newIndexPath;

- (void)notifySectionsInserted:(NSIndexSet *)sections;
- (void)notifySectionsRemoved:(NSIndexSet *)sections;
- (void)notifySectionMovedFrom:(NSInteger)section to:(NSInteger)newSection;
- (void)notifySectionsRefreshed:(NSIndexSet *)sections;

- (void)notifyDidReloadData;

- (void)notifyBatchUpdate:(dispatch_block_t)update;
- (void)notifyBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete;

- (void)notifyWillLoadContent;
- (void)notifyContentLoadedWithError:(NSError *)error;

#pragma mark - Placeholders

@property (nonatomic, assign) BOOL adjustPlacholderHeightAutomatically; //Default is YES;
@property (nonatomic, strong) UITableViewCell<ISFPlaceholderCell> *placeholderView;

/// Is this data source "hidden" by a placeholder either of its own or from an enclosing data source. Use this to determine whether to report that there are no items in your data source while loading.
@property (nonatomic, readonly) BOOL obscuredByPlaceholder;

#pragma mark - Subclass hooks

/// Determine whether or not a cell is editable. Default implementation returns YES.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/// Determine whether or not the cell is movable. Default implementation returns NO.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

/// Called by the collection view to alert the data source that an item has been moved. The data source should update its contents.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

/// Register reusable views needed by this data source
- (void)registerReusableViewsWithTableView:(UITableView *)tableView;

- (UITableViewCell *)prototypeCellForIndexPath:(NSIndexPath *)indexPath;

/**
 Load content if loading state if initial
 
 @param forced Reload content forcefully
 */
- (void)loadContentIfNeeded:(BOOL)forced;

- (void)setNeedsLoadContentAfterDelay:(NSTimeInterval)delay;

/// Load the content of this data source.
- (void)loadContent;

/// Reset the content and loading state.
- (void)resetContent NS_REQUIRES_SUPER;

/// Use this method to wait for content to load. The block will be called once the loadingState has transitioned to the ContentLoaded, NoContent, or Error states. If the data source is already in that state, the block will be called immediately.
- (void)whenLoaded:(dispatch_block_t)block;

- (void)setNeedLoadSearchContentWithQuery:(NSString *)query;
- (void)loadSearchContentWithQuery:(NSString *)query;

- (void)handleRowSelectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SFDataSource (SFPagedDataSourceAdditions)
- (void)setNeedLoadNextPage;
@end


