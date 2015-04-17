//
//  KLEventListDataSource.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListDataSource.h"
#import "SFBasicPaginator.h"
#import "KLEventListCell.h"

static NSString *klEventListCellReuseId = @"EventListCell";

@implementation KLEventListDataSource

- (instancetype)init
{
    if (self = [super init]) {
        PFQuery *query = [KLEvent query];
        SFBasicPaginator *paginator = [[SFBasicPaginator alloc] initWithQuery:query
                                                                        limit:5];
        self.paginator = paginator;
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

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    KLEventListCell *cell = (KLEventListCell *)[tableView dequeueReusableCellWithIdentifier:klEventListCellReuseId
                                                                               forIndexPath:indexPath];
    return cell;
}

@end
