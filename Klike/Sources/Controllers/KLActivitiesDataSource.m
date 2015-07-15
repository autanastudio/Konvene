//
//  KLActivitiesDataSource.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivitiesDataSource.h"
#import "KLPlaceholderCell.h"
#import "KLActivityCell.h"
#import "KLActivityFollowCell.h"
#import "KLActivityFollowGroupCell.h"
#import "KLActivityEventCell.h"
#import "KLActivityEventGroupCell.h"
#import "KLActivityPhotoGroupCell.h"

@interface KLActivitiesDataSource () <KLActivityCellDelegate>

@end

@implementation KLActivitiesDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"Your events activity will be here.\nExplore events or create one!"
                                                                  image:[UIImage imageNamed:@"empty_state"]
                                                            buttonTitle:nil
                                                           buttonAction:nil];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:[KLActivityFollowCell reuseIdentifier]
                                          bundle:nil]
    forCellReuseIdentifier:[KLActivityFollowCell reuseIdentifier]];
    [tableView registerNib:[UINib nibWithNibName:[KLActivityFollowGroupCell reuseIdentifier]
                                          bundle:nil]
    forCellReuseIdentifier:[KLActivityFollowGroupCell reuseIdentifier]];
    [tableView registerNib:[UINib nibWithNibName:[KLActivityEventCell reuseIdentifier]
                                          bundle:nil]
    forCellReuseIdentifier:[KLActivityEventCell reuseIdentifier]];
    [tableView registerNib:[UINib nibWithNibName:[KLActivityEventGroupCell reuseIdentifier]
                                          bundle:nil]
    forCellReuseIdentifier:[KLActivityEventGroupCell reuseIdentifier]];
    [tableView registerNib:[UINib nibWithNibName:[KLActivityPhotoGroupCell reuseIdentifier]
                                          bundle:nil]
    forCellReuseIdentifier:[KLActivityPhotoGroupCell reuseIdentifier]];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLActivityCell *cell;
    KLActivity *activity = (KLActivity *)[self itemAtIndexPath:indexPath];
    switch ([activity.activityType integerValue]) {
        case KLActivityTypeFollow:
        case KLActivityTypeFollowMe:{
            if (activity.users.count>1) {
                cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityFollowGroupCell reuseIdentifier]];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityFollowCell reuseIdentifier]];
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
        case KLActivityTypeCommentAddedToAttendedEvent:{
            cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityEventCell reuseIdentifier]];
        }break;
        case KLActivityTypeGoesToMyEvent:{
            if (activity.users.count>1) {
                cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityEventGroupCell reuseIdentifier]];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityEventCell reuseIdentifier]];
            }
        }break;
        case KLActivityTypePhotosAdded:{
            cell = [tableView dequeueReusableCellWithIdentifier:[KLActivityPhotoGroupCell reuseIdentifier]];
        }break;
        default:
            break;
    }
    cell.delegate = self;
    [cell configureWithActivity:activity];
    return cell;
}

-(PFQuery *)buildQuery
{
    PFQuery *query = [KLActivity query];
    query.limit = 10;
    [query whereKey:sf_key(observers) equalTo:[KLAccountManager sharedManager].currentUser.userObject.objectId];
    [query includeKey:sf_key(event)];
    [query includeKey:sf_key(from)];
    [query includeKey:sf_key(users)];
    [query includeKey:sf_key(photos)];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(event), sf_key(location)]];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(event), sf_key(price)]];
    [query orderByDescending:sf_key(updatedAt)];
    return query;
}

#pragma mark - KLActivityCellDelegate methods

- (void)activityCell:(KLActivityCell *)cell showUserProfile:(KLUserWrapper *)user
{
    if (self.listDelegate && [self.listDelegate respondsToSelector:@selector(showUserProfile:)]) {
        [self.listDelegate showUserProfile:user];
    }
}

@end
