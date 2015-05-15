//
//  KLCardDataSource.m
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCardDataSource.h"
#import "KLCardCell.h"

static NSString *klCardCellIdentifier = @"CardCell";

@interface KLCardDataSource ()

@property (nonatomic, strong) KLUserWrapper *user;

@end

@implementation KLCardDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [KLAccountManager sharedManager].currentUser;
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    UINib *nib = [UINib nibWithNibName:klCardCellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:klCardCellIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLCardCell *cell = (KLCardCell *)[tableView dequeueReusableCellWithIdentifier:klCardCellIdentifier
                                                                             forIndexPath:indexPath];
    [cell configureWithCard:[self itemAtIndexPath:indexPath]];
    return cell;
}

- (void)loadContent
{
    [self loadContentWithBlock:^(SFLoading *loading) {
        [loading updateWithContent:^(KLCardDataSource *dataSource) {
            KLUserPayment *payment = [KLAccountManager sharedManager].currentUser.paymentInfo;
            PFQuery *query = [KLUserPayment query];
            [query includeKey:sf_key(cards)];
            [query getObjectInBackgroundWithId:payment.objectId
                                         block:^(PFObject *object, NSError *error) {
                                             KLUserPayment *fetchPayment = (KLUserPayment *)object;
                                             dataSource.items = fetchPayment.cards;
            }];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak typeof(self) weakSelf = self;
        [[KLAccountManager sharedManager] deleteCard:[self itemAtIndexPath:indexPath]
                                    withCompletition:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            [weakSelf removeItemAtIndexPath:indexPath];
                                        }
                                    }];
    }
}

@end
