//
//  KLUsersTableViewController.m
//  Klike
//
//  Created by Дмитрий Александров on 30.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUsersTableViewController.h"
#import "KLAccountManager.h"

@interface KLUsersTableViewController ()
@property KLUserListType type;
@property KLUserWrapper *user;
@end

@implementation KLUsersTableViewController

- (instancetype) initWithUser:(KLUserWrapper *)user type:(KLUserListType)type {
    self = [super initWithStyle:UITableViewStylePlain className:@"FollowAction"];
    if (self) {
        self.title = @"Users";
        self.textKey = @"fullName";
        self.objectsPerPage = 25;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (PFQuery *)queryForTable {
    PFQuery *query = [[PFQuery alloc] init];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"text"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    
    return cell;
}

@end
