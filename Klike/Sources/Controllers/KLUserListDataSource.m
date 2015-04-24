//
//  KLUserListDataSource.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserListDataSource.h"
#import "KLUserListCell.h"

static NSString *klCellReuseId = @"UserListCell";

@implementation KLUserListDataSource

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
    KLUserListCell *cell = (KLUserListCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                             forIndexPath:indexPath];
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
    [cell configureWithUser:user];
    return cell;
}

@end