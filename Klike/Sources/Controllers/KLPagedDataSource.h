//
//  KLPagedDataSource.h
//  Klike
//
//  Created by admin on 20/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFBasicDataSource.h"

extern NSString * const SFLoadingNextCellIdentifier;

@interface KLPagedDataSource : SFBasicDataSource
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic) UIColor *loadingCellBackgroundColor;

@property (nonatomic, readonly) UITableViewCell<ISFLoadingNextCell> *loadingNextCell;

/**
 *  Add new items to the end of list.
 *
 *  @param items new items
 */
- (void)appendItems:(NSArray *)items;
/**
 *  Add new items to the start if list.
 *
 *  @param items new items.
 */
- (void)insertItems:(NSArray *)items;
/**
 *  Registres loading next cell class with table view;
 *
 */
- (void)registerReusableViewsWithTableView:(UITableView *)tableView NS_REQUIRES_SUPER;

- (void)setNeedLoadNextPage;
- (void)loadNextPage;
- (PFQuery *)buildQuery;

- (void)notifyLoadFirstPage;

- (void)insertItemsWithPaginatorUpdate:(NSArray *)items;

- (void)updateLoadingNextCell:(UITableViewCell<ISFLoadingNextCell> *)cell;
- (UITableViewCell<ISFLoadingNextCell> *)dequeueLoadingNextCellForTableView:(UITableView *)tableView
                                                                atIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;


@end