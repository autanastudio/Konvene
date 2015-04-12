//
//  KLEnumDataSource.m
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEnumDataSource.h"
#import "KLEnumTableViewCell.h"

static NSString *klEnumCellId = @"klEnumCellId";

@implementation KLEnumDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"EnumTableViewCell"
                                          bundle:nil]
    forCellReuseIdentifier:klEnumCellId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEnumTableViewCell *cell = (KLEnumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:klEnumCellId
                                                                                       forIndexPath:indexPath];
    [cell configureWithEnumObject:[self itemAtIndexPath:indexPath]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
