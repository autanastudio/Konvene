//
//  KLExploreEventListController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventListController.h"
#import "KLExploreEventDataSource.h"

@interface KLExploreEventListController ()

@end

@implementation KLExploreEventListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    PFQuery *query = [KLEvent query];
    query.limit = 2;
    [query includeKey:sf_key(location)];
    KLExploreEventDataSource *dataSource = [[KLExploreEventDataSource alloc] initWithQuery:query];
    return dataSource;
}

- (NSString *)title
{
    return SFLocalized(@"explore.events.title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175.;
}

@end
