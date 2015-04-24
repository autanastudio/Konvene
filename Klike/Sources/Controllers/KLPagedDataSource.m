//
//  KLPagedDataSource.m
//  Klike
//
//  Created by admin on 20/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPagedDataSource.h"

NSString * const SFLoadingNextCellIdentifier = @"SFLoadingNextCellIdentifier";

@interface KLPagedDataSource ()

@property (nonatomic, strong) UITableViewCell<ISFLoadingNextCell> *loadingNextCell;

@end

@implementation KLPagedDataSource

- (instancetype)initWithQuery:(PFQuery *)query
{
    if (self = [super init]) {
        self.query = query;
        self.hasNextPage = YES;
        self.currentPage = 1;
    }
    return self;
}


- (void)dealloc
{
    [self unsubscribeFromAllNotifications];
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [tableView registerClass:[SFLoadingNextCell class]
      forCellReuseIdentifier:SFLoadingNextCellIdentifier];
}

- (void)appendItems:(NSArray *)items
{
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
    [newItems addObjectsFromArray:items];
    self.items = newItems.copy;
}

- (void)insertItems:(NSArray *)items
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)];
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
    [newItems insertObjects:items atIndexes:indexSet];
    self.items = newItems.copy;
}

- (void)insertItemsWithPaginatorUpdate:(NSArray *)items
{
    [self insertItems:items];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [super removeItemsAtIndexes:indexes];
}

- (void)didEnterLoadingNextState
{
    [self updateLoadingNextCell:self.loadingNextCell];
}

- (void)didEnterErrorNextState
{
    [self updateLoadingNextCell:self.loadingNextCell];
}

- (void)beginLoading
{
    self.loadingComplete = NO;
    if ([self.loadingState isEqualToString:SFLoadStateInitial] || [self.loadingState isEqualToString:SFLoadStateLoadingContent]) {
        self.loadingState = SFLoadStateLoadingContent;
    } else if (self.loadingState == SFLoadStateLoadingNextContent) {
        self.loadingState = SFLoadStateLoadingNextContent;
    } else {
        self.loadingState = SFLoadStateRefreshingContent;
    }
    [self notifyWillLoadContent];
}

- (void)loadContent
{
    __weak typeof(self) weakSelf = self;
    self.hasNextPage = YES;
    self.currentPage = 1;
    self.query.skip = 0;
    [self loadContentWithBlock:^(SFLoading *loading) {
        [weakSelf.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            if (!error) {
                [loading updateWithContent:^(KLPagedDataSource *dataSource) {
                    dataSource.items = objects;
                }];
            } else {
                [loading doneWithError:error];
            }
        }];
    }];
}


- (void)setNeedLoadNextPage
{
    if (self.hasNextPage &&
        !self.obscuredByPlaceholder &&
        self.loadingState != SFLoadStateRefreshingContent &&
        self.loadingState != SFLoadStateLoadingNextContent)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadNextPage) object:nil];
        [self performSelector:@selector(loadNextPage) withObject:nil afterDelay:0];
    }
}

- (void)loadNextPage
{
    __weak typeof(self) weakSelf = self;
    self.loadingState = SFLoadStateLoadingNextContent;
    [self loadContentWithBlock:^(SFLoading *loading) {
        weakSelf.query.skip = weakSelf.currentPage*weakSelf.query.limit;
        [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            if (!error) {
                if (objects.count!=weakSelf.query.limit) {
                    weakSelf.hasNextPage = NO;
                } else {
                    weakSelf.currentPage ++;
                }
                [loading updateWithContent:^(KLPagedDataSource *dataSource) {
                    [dataSource appendItems:objects];
                }];
            } else {
                [loading doneWithError:error];
            }
        }];
    }];
}

- (void)updateLoadingNextCell:(UITableViewCell<ISFLoadingNextCell> *)cell
{
    NSString *loadingState = self.loadingState;
    if ([loadingState isEqualToString:SFLoadStateErrorNext]) {
        [cell showRertyButton:YES];
        [cell showLoadingIndicator:NO];
    } else {
        [cell showLoadingIndicator:YES];
        [cell showRertyButton:NO];
    }
}

- (UITableViewCell<ISFLoadingNextCell> *)dequeueLoadingNextCellForTableView:(UITableView *)tableView
                                                                atIndexPath:(NSIndexPath *)indexPath
{
    if (!self.loadingNextCell) {
        self.loadingNextCell = [tableView dequeueReusableCellWithIdentifier:SFLoadingNextCellIdentifier forIndexPath:indexPath];
        [self.loadingNextCell.retryButton addTarget:self
                                             action:@selector(setNeedLoadNextPage)
                                   forControlEvents:UIControlEventTouchUpInside];
    }
    [self updateLoadingNextCell:self.loadingNextCell];
    return self.loadingNextCell;
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSAssert(false, @"Should be implemented by subclasses");
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.obscuredByPlaceholder)
        return 1;
    
    return self.items.count + (self.hasNextPage ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.obscuredByPlaceholder) {
        return [self dequeuePlaceholderViewForTableView:tableView atIndexPath:indexPath];
    }
    if (![self itemAtIndexPath:indexPath]) {
        return [self dequeueLoadingNextCellForTableView:tableView atIndexPath:indexPath];
    }
    return [self cellAtIndexPath:indexPath inTableView:tableView];
}

- (void)handleRowSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO
//    if (indexPath.row == self.items.count) {
//        if (self.paginator.totalObjects > self.items.count) {
//            [self setNeedLoadNextPage];
//        }
//    }
}

@end
