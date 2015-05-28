//
//  KLStatsDataSource.m
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLStatsDataSource.h"
#import "KLChargeCell.h"
#import "KLPlaceholderCell.h"

static NSString *klChargeCellIdentifier = @"ChargeCell";

@interface KLStatsDataSource ()

@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLStatsDataSource

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.sortByAmount = NO;
        self.event = event;
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"A list of users, who bought tickets will be here."
                                                                  image:nil
                                                            buttonTitle:nil
                                                           buttonAction:nil];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    UINib *nib = [UINib nibWithNibName:klChargeCellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:klChargeCellIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self obscuredByPlaceholder]) {
        return self.placeholderView;
    }
    KLChargeCell *cell = (KLChargeCell *)[tableView dequeueReusableCellWithIdentifier:klChargeCellIdentifier
                                                                         forIndexPath:indexPath];
    KLCharge *charge = (KLCharge *)[self itemAtIndexPath:indexPath];
    charge.event = self.event;
    [cell configureWithCharge:charge];
    return cell;
}

- (void)loadContent
{
    __weak typeof(self) weakSelf = self;
    [self loadContentWithBlock:^(SFLoading *loading) {
        PFQuery *query = [KLCharge query];
        if (self.sortByAmount) {
            [query orderByDescending:sf_key(amount)];
        } else {
            [query orderByDescending:sf_key(createdAt)];
        }
        [query includeKey:sf_key(owner)];
        [query whereKey:sf_key(event)
                equalTo:weakSelf.event];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [loading updateWithContent:^(SFBasicDataSource *dataSource) {
                dataSource.items = objects;
            }];
        }];
    }];
}

@end
