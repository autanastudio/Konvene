//
//  KLInvitedDataSource.m
//  Klike
//
//  Created by Alexey on 7/24/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInvitedDataSource.h"
#import "KLInviteduserListCell.h"
#import "KLPlaceholderCell.h"

static NSString *klCellReuseId = @"InviteduserListCell";

@interface KLInvitedDataSource ()

@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLInvitedDataSource

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.event = event;
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"No one is currently invited!"
                                                                  image:[UIImage imageNamed:@"empty_state"]
                                                            buttonTitle:nil
                                                           buttonAction:nil];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCellReuseId];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLInviteduserListCell *cell = (KLInviteduserListCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                             forIndexPath:indexPath];
    KLInvite *invite = [self itemAtIndexPath:indexPath];
    invite.event = self.event;
    [cell configureWithInvite:invite];
    if (indexPath.row == self.items.count-1) {
        cell.separator.hidden = YES;
    } else {
        cell.separator.hidden = NO;
    }
    return cell;
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [KLInvite query];
    query.limit = 10;
    [query whereKey:sf_key(event)
            equalTo:self.event];
    [query includeKey:sf_key(to)];
    return query;
}

@end
