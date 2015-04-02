//
//  KLUsersTableViewController.m
//  Klike
//
//  Created by Дмитрий Александров on 30.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUsersTableViewController.h"
#import "KLAccountManager.h"
#import "KLUserTableViewCell.h"

@interface KLUsersTableViewController () <KLUserTableViewCellDelegate>
@property KLUserListType type;
@property KLUserWrapper *user;
@end

static NSString *userCellIdentifier = @"userCell";

@implementation KLUsersTableViewController

- (instancetype)initWithUser:(KLUserWrapper *)user
                        type:(KLUserListType)type {
    self = [super initWithStyle:UITableViewStylePlain className:@"FollowAction"];
    if (self) {
        self.title = @"Users";
        self.textKey = @"fullName";
        self.objectsPerPage = 25;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (PFQuery *)queryForTable {
    PFQuery *query = nil;
    switch (self.type) {
        case KLUserListTypeFollowers:
            query = [[KLAccountManager sharedManager] getFollowersQueryForUser:self.user];
            break;
        case KLUserListTypeFollowing:
            query = [[KLAccountManager sharedManager] getFollowingQueryForUser:self.user];
            break;
        default:
            break;
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    KLUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    if (cell == nil) {
        cell = [[KLUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:userCellIdentifier];
    }
    
    // Configure the cell
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
//    cell.textLabel.text = [object objectForKey:@"text"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    [cell configureWithUser:user];
    return cell;
}

#pragma mark KLUserTableViewCellDelegate
- (void) cellDidClickFollow:(KLUserTableViewCell *)cell
{
    
}

@end
