//
//  KLUsersTableViewController.m
//  Klike
//
//  Created by Дмитрий Александров on 30.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUsersTableViewController.h"

@interface KLUsersTableViewController ()
@property KLUserListType type;
@property KLUserWrapper *user;
@end

@implementation KLUsersTableViewController

- (instancetype) initWithUser:(KLUserWrapper *)user type:(KLUserListType)type {
    self = [super initWithClassName:@"_User"];
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
    PFQuery *query = [PFUser query];
    switch (self.type) {
        case KLUserListTypeBoth:
            break;
        case KLUserListTypeFollowers:
            [query whereKey:@"followed" equalTo:self.user];
            [query includeKey:@"follower"];
            break;
        case KLUserListTypeFollowing:
            [query whereKey:@"follower" equalTo:self.user];
            [query includeKey:@"followed"];
            break;
        default:
            break;
    }
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByAscending:@"priority"];
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
