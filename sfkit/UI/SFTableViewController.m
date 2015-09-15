//
//  SFTablewViewController.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFTableViewController.h"
#import "SFDataSource.h"
#import "SFDataSource_Private.h"
#import "SFBasicDataSourceAdapter.h"

static void * const SFDataSourceContext = @"DataSourceContext";

@interface SFTableViewController () <SFDataSourceDelegate>
@end

@implementation SFTableViewController
@synthesize dataSourceDelegate = _dataSourceDelegate;

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"dataSource" context:SFDataSourceContext];
}

- (void)loadView
{
    [super loadView];
    [self.tableView addObserver:self
                     forKeyPath:@"dataSource"
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:SFDataSourceContext];
}

- (id<SFDataSourceDelegate>)dataSourceDelegate
{
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[SFBasicDataSourceAdapter alloc] initWithTableView:self.tableView];
        ((SFBasicDataSourceAdapter *)_dataSourceDelegate).delegate = self;
    }
    return _dataSourceDelegate;
}

- (void)setDataSourceDelegate:(id<SFDataSourceDelegate>)dataSourceDelegate
{
    _dataSourceDelegate = dataSourceDelegate;
    SFDataSource *dataSource = (SFDataSource *)self.tableView.dataSource;
    if ([dataSource isKindOfClass:[SFDataSource class]]) {
        dataSource.delegate = _dataSourceDelegate;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UITableView *tablewView = self.tableView;
    
    SFDataSource *dataSource = (SFDataSource *)tablewView.dataSource;
    if ([dataSource isKindOfClass:[SFDataSource class]]) {
        [dataSource loadContentIfNeeded:NO];
    }
}

- (void)setTableView:(UITableView *)tableView
{
    UITableView *oldTableView = self.tableView;
    
    // Always call super, because we don't know EXACTLY what UITablewViewController does in -setTableView:.
    [super setTableView:tableView];
    [oldTableView removeObserver:self forKeyPath:@"dataSource" context:SFDataSourceContext];
    [tableView addObserver:self
                forKeyPath:@"dataSource"
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionInitial
                   context:SFDataSourceContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (SFDataSourceContext != context) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    UITableView *tableView = object;
    id<UITableViewDataSource> dataSource = tableView.dataSource;
    if ([dataSource isKindOfClass:[SFDataSource class]]) {
        SFDataSource *sfDataSource = (SFDataSource *)dataSource;
        if (!sfDataSource.delegate) {
            [sfDataSource registerReusableViewsWithTableView:tableView];
            sfDataSource.delegate = self.dataSourceDelegate;
        }
    }
}

- (void)didReachEndOfList
{
    // Should be implemented by subclassed if needed
}

- (void)onRefreshContent
{
    [(SFDataSource *)self.tableView.dataSource loadContentIfNeeded:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (void)handleScrollDidStop
{
    NSInteger lastSection = self.tableView.numberOfSections - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:lastSection] - 1
                                                    inSection:lastSection];
    if ([self.tableView.indexPathsForVisibleRows containsObject:lastIndexPath]) {
        [self didReachEndOfList];
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
