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
        switch (type) {
            case KLUserListTypeFollowers:
                self.title = @"Followers";
                break;
            case KLUserListTypeFollowing:
                self.title = @"Following";
                break;
            default:
                self.title = @"Users";
                break;
        }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    [self kl_setNavigationBarColor:[UIColor whiteColor]];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]
                                                                 target:self
                                                               selector:@selector(onBack)];
}

- (void)onBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
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
