//
//  KLPaymentsHistoryDataSource.m
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentsHistoryDataSource.h"
#import "KLPaymentHistoryCell.h"

static NSString *klPaymentListCellReuseId = @"PaymanetsHistoryCell";

@interface KLPaymentsHistoryDataSource ()

@end

@implementation KLPaymentsHistoryDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klPaymentListCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klPaymentListCellReuseId];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLPaymentHistoryCell *cell = (KLPaymentHistoryCell *)[tableView dequeueReusableCellWithIdentifier:klPaymentListCellReuseId
                                                                                         forIndexPath:indexPath];
    [cell configureWithCharge:[self itemAtIndexPath:indexPath]];
    return cell;
}

- (PFQuery *)buildQuery
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    PFQuery *query = [KLCharge query];
    query.limit = 10;
    [query includeKey:sf_key(event)];
    [query includeKey:sf_key(card)];
    [query includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(event), sf_key(price)]];
    [query whereKey:sf_key(owner) equalTo:currentUser.userObject];
    [query orderByDescending:sf_key(createdAt)];
    return query;
}

@end
