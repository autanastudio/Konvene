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
    self = [super initWithClassName:@"User"];
    if (self) {
        self.title = @"Users";
        self.textKey = @"fullName";
        self.parseClassName = @"User";
        self.objectsPerPage = 25;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.type = type;
        [self.tableView registerNib:[UINib nibWithNibName:@"KLUserTableViewCell"
                                                   bundle:nil] forCellReuseIdentifier:userCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
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
    [query orderByAscending:@"fullName"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    KLUserTableViewCell *cell = (KLUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:userCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[KLUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:userCellIdentifier];
    }
    
    // Configure the cell
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
//    cell.textLabel.text = [object objectForKey:@"text"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithUser:user];
    return cell;
}

#pragma mark KLUserTableViewCellDelegate
- (void) cellDidClickFollow:(KLUserTableViewCell *)cell
{
    [[KLAccountManager sharedManager] follow:![[KLAccountManager sharedManager]isFollowing:cell.user]
                                        user:cell.user
                            withCompletition:^(BOOL succeeded, NSError *error) {
                                [cell update];
    }];
}

@end
