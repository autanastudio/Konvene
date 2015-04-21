//
//  KLListViewController.m
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"
#import "SFBasicDataSource.h"
#import "KLPagedDataSource.h"

@interface KLListViewController ()

@end

@implementation KLListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.dataSourceAdapter = [[SFBasicDataSourceAdapter alloc] initWithTableView:self.tableView];
    self.tableView.delegate = self;
    self.dataSource = [self buildDataSource];
    self.dataSource.delegate = self.dataSourceAdapter;
    self.tableView.dataSource = self.dataSource;
    self.dataSourceAdapter.delegate = self;
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.contentInsetBottom = 0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataSource loadContentIfNeeded:NO];
}

- (SFDataSource *)buildDataSource
{
    return [[SFBasicDataSource alloc] init];
}

- (void)refreshList
{
    [self.dataSource loadContentIfNeeded:YES];
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom
{
    _contentInsetBottom = contentInsetBottom;
    if (self.tableView == nil)
        return;
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = contentInsetBottom;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

#pragma mark - UITableViewDelegate

- (void)didReachEndOfList
{
    if (![self.dataSource.loadingState isEqualToString:SFLoadStateErrorNext]) {
        [self.dataSource setNeedLoadNextPage];
    }
}

- (void)handleScrollDidStop
{
    NSInteger lastSection = self.tableView.numberOfSections - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:lastSection] - 1
                                                    inSection:lastSection];
    if ([self.tableView.indexPathsForVisibleRows containsObject:lastIndexPath]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
        if ([cell.reuseIdentifier isEqualToString:SFLoadingNextCellIdentifier]) {
            [self didReachEndOfList];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        [self handleScrollDidStop];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollDidStop];
}

@end
