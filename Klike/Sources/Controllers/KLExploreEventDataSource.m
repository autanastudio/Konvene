//
//  KLExploreEventDataSource.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventDataSource.h"
#import "KLExploreEventCell.h"

static NSString *klEventListCellReuseId = @"ExploreEventCell";

@interface KLExploreEventDataSource () <KLExploreEventCellDelegate>

@end

@implementation KLExploreEventDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klEventListCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klEventListCellReuseId];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLExploreEventCell *cell = (KLExploreEventCell *)[tableView dequeueReusableCellWithIdentifier:klEventListCellReuseId
                                                                               forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureWithEvent:[self itemAtIndexPath:indexPath]];
    return cell;
}

- (PFQuery *)buildQuery
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    PFQuery *query = [KLEvent query];
    query.limit = 3;
    [query includeKey:sf_key(location)];
    [query includeKey:sf_key(price)];
    [query orderByDescending:sf_key(createdAt)];
    [query whereKey:sf_key(owner)
         notEqualTo:currentUser.userObject];
    return query;
}

- (void)exploreEventCell:(KLExploreEventCell *)cell
   showAttendiesForEvent:(KLEvent *)event
{
    if (self.listDelegate && [self.listDelegate respondsToSelector:@selector(exploreEventDataSource:showAttendiesForEvent:)] ) {
        [self.listDelegate exploreEventDataSource:self
                            showAttendiesForEvent:event];
    }
}

@end
