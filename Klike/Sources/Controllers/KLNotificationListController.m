//
//  KLNotificationListController.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLNotificationListController.h"
#import "KLActivityIndicator.h"
#import "KLActivitiesDataSource.h"

static CGFloat klActivityCellEstimatedHeight = 70.;

@interface KLNotificationListController ()

@end

@implementation KLNotificationListController

- (NSString *)title
{
    return SFLocalized(@"activity.tab.everything");
}

- (SFDataSource *)buildDataSource
{
    KLActivitiesDataSource *dataSource = [[KLActivitiesDataSource alloc] init];
    return dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klActivityCellEstimatedHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    //TODO
}

@end
