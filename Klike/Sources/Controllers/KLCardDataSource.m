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
    if(self.obscuredByPlaceholder){
        return [self dequeuePlaceholderViewForTableView:tableView
                                            atIndexPath:indexPath];
    }
    KLCardCell *cell = (KLCardCell *)[tableView dequeueReusableCellWithIdentifier:klCardCellIdentifier
                                                                             forIndexPath:indexPath];
    [cell configureWithCard:[self itemAtIndexPath:indexPath]];
    return cell;
}

- (void)loadContent
{
//    __weak typeof(self) weakSelf = self;
    [self loadContentWithBlock:^(SFLoading *loading) {
        [loading updateWithContent:^(KLCardDataSource *dataSource) {
            dataSource.items = @[@1, @2, @3];
        }];
    }];
}

@end
