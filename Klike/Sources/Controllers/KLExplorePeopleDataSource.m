//
//  KLExplorePeopleDataSource.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleDataSource.h"
#import "KLExplorePeopleCell.h"
#import "KLExplorePeopleTopCell.h"

static NSString *klCellReuseId = @"ExplorePeopleCell";
static NSString *klEventListTopUserCell = @"ExplorePeopleTopCell";

@implementation KLExplorePeopleDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCellReuseId];
    [tableView registerNib:[UINib nibWithNibName:klEventListTopUserCell
                                          bundle:nil]
    forCellReuseIdentifier:klEventListTopUserCell];
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
    [query orderByDescending:sf_key(raiting)];
    return query;
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLExplorePeopleCell *cell;
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
    if (indexPath.row == 0 && user.createdEvents.count >= 3) {
        cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klEventListTopUserCell
                                                                      forIndexPath:indexPath];
    } else {
        cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                      forIndexPath:indexPath];
    }
    [cell configureWithUser:user];
    return cell;
}

@end
