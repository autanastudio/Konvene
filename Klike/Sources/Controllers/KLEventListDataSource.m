//
//  KLEventListDataSource.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListDataSource.h"
#import "KLEventListCell.h"

static NSString *klEventListCellReuseId = @"EventListCell";

@interface KLEventListDataSource () <KLEventListCellDelegate>

@end

@implementation KLEventListDataSource

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
    KLEventListCell *cell = (KLEventListCell *)[tableView dequeueReusableCellWithIdentifier:klEventListCellReuseId
                                                                               forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureWithEvent:[self itemAtIndexPath:indexPath]];
    return cell;
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [KLEvent query];
    switch (self.type) {
        case KLEventListDataSourceTypeCreated:{
            query = [[KLEventManager sharedManager] getCreatedEventsQueryForUser:self.user];
        }break;
        case KLEventListDataSourceTypeGoing:{
            
        }break;
        case KLEventListDataSourceTypeSaved:{
            
        }break;
            
        default:
            break;
    }
    query.limit = 5;
    [query includeKey:sf_key(location)];
    [query includeKey:sf_key(price)];
    [query orderByDescending:sf_key(createdAt)];
    return query;
}

#pragma mark - KLEventListDataSource methods

- (void)eventListCell:(KLEventListCell *)cell
showAttendiesForEvent:(KLEvent *)event
{
    if (self.listDelegate && [self.listDelegate respondsToSelector:@selector(eventListDataSource:showAttendiesForEvent:)]) {
        [self.listDelegate eventListDataSource:self
                         showAttendiesForEvent:event];
    }
}

@end
