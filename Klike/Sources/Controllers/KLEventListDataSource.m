//
//  KLEventListDataSource.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListDataSource.h"
#import "KLEventListCell.h"
#import "KLPlaceholderCell.h"

static NSString *klEventListCellReuseId = @"EventListCell";

@interface KLEventListDataSource () <KLEventListCellDelegate>

@end

@implementation KLEventListDataSource

- (instancetype)initWithUser:(KLUserWrapper *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        if (self.user) {
            switch (self.type) {
                case KLEventListDataSourceTypeCreated:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:[NSString stringWithFormat:@"%@ hasn't created any events yet.", self.user.fullName]
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                case KLEventListDataSourceTypeGoing:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:[NSString stringWithFormat:@"%@ is not going anywhere yet.", self.user.fullName]
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                case KLEventListDataSourceTypeSaved:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:[NSString stringWithFormat:@"%@ hasn't saved any events yet.", self.user.fullName]
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                default:
                    break;
            }
        } else {
            switch (self.type) {
                case KLEventListDataSourceTypeCreated:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:@"Your events will be listed here.\nCreate event!"
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                case KLEventListDataSourceTypeGoing:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:@"Your upcoming events will be here.\nExplore local events to find something awesome."
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                case KLEventListDataSourceTypeSaved:{
                    self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                            message:@"Tap Save on the events, that interest you and they will appear here."
                                                                              image:[UIImage imageNamed:@"empty_state"]
                                                                        buttonTitle:nil
                                                                       buttonAction:nil];
                }break;
                default:
                    break;
            }
        }
    }
    return self;
}

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
            query = [[KLEventManager sharedManager] getGoingEventsQueryForUser:self.user];
        }break;
        case KLEventListDataSourceTypeSaved:{
            query = [[KLEventManager sharedManager] getSavedEventsQueryForUser:self.user];
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
