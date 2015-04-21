//
//  KLExploreEventDataSource.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventDataSource.h"
#import "KLEventListCell.h"

static NSString *klEventListCellReuseId = @"EventListCell";

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
    KLEventListCell *cell = (KLEventListCell *)[tableView dequeueReusableCellWithIdentifier:klEventListCellReuseId
                                                                               forIndexPath:indexPath];
    [cell configureWithEvent:[self itemAtIndexPath:indexPath]];
    return cell;
}

@end
