//
//  KLInvitionsDataSource.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInvitionsDataSource.h"
#import "KLInviteCell.h"

static NSString *klInviteListCellReuseId = @"InviteCell";

@interface KLInvitionsDataSource ()

@end

@implementation KLInvitionsDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klInviteListCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klInviteListCellReuseId];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLInviteCell *cell = (KLInviteCell *)[tableView dequeueReusableCellWithIdentifier:klInviteListCellReuseId
                                                                         forIndexPath:indexPath];
    [cell configureWithInvite:[self itemAtIndexPath:indexPath]];
    return cell;
}

-(PFQuery *)buildQuery
{
    PFQuery *query = [KLInvite query];
    query.limit = 10;
    [query whereKey:sf_key(to) equalTo:[KLAccountManager sharedManager].currentUser.userObject];
    [query includeKey:sf_key(event)];
    [query includeKey:sf_key(from)];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(event), sf_key(location)]];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(event), sf_key(price)]];
    [query orderByDescending:sf_key(createdAt)];
    return query;
}

@end
