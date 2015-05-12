//
//  KLExplorePeopleDataSource.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleDataSource.h"
#import "KLExplorePeopleCell.h"

static NSString *klCellReuseId = @"ExplorePeopleCell";

@implementation KLExplorePeopleDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCellReuseId];
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query includeKey:sf_key(location)];
    NSArray *excludingIds = [KLAccountManager sharedManager].currentUser.following;
    excludingIds = [excludingIds arrayByAddingObjectsFromArray:@[[KLAccountManager sharedManager].currentUser.userObject.objectId]];
    [query whereKey:sf_key(objectId)
     notContainedIn:excludingIds];
    return query;
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLExplorePeopleCell *cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                                     forIndexPath:indexPath];
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
    [cell configureWithUser:user];
    return cell;
}

@end
