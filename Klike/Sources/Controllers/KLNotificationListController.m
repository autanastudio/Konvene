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

@interface KLNotificationListController () <KLActivitiesDataSourceDelegate>

@end

@implementation KLNotificationListController

- (NSString *)title
{
    return SFLocalized(@"activity.tab.everything");
}

- (SFDataSource *)buildDataSource
{
    KLActivitiesDataSource *dataSource = [[KLActivitiesDataSource alloc] init];
    dataSource.listDelegate = self;
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
    KLActivity *activity = [self.dataSource itemAtIndexPath:indexPath];
    switch ([activity.activityType integerValue]) {
        case KLActivityTypeFollow:{
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(notificationList:openUserProfile:)]
                && activity.from) {
                [self.delegate notificationList:self
                                openUserProfile:[[KLUserWrapper alloc] initWithUserObject:activity.from]];
            }
        }break;
        case KLActivityTypeCreateEvent:
        case KLActivityTypeGoesToEvent:
        case KLActivityTypeEventCanceled:
        case KLActivityTypeEventChangedName:
        case KLActivityTypeEventChangedLocation:
        case KLActivityTypeEventChangedTime:
        case KLActivityTypeCommentAdded:
        case KLActivityTypePayForEvent:
        case KLActivityTypeGoesToMyEvent:
        case KLActivityTypePhotosAdded:{
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(notificationListOCntroller:showEventDetails:)]
                && activity.event) {
                [self.delegate notificationListOCntroller:self
                                         showEventDetails:activity.event];
            }
        }break;
        default:
            break;
    }
}

#pragma mark - KLActivitiesDataSourceDelegate methods

- (void)showUserProfile:(KLUserWrapper *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificationList:openUserProfile:)]) {
        [self.delegate notificationList:self
                        openUserProfile:user];
    }
}

@end
