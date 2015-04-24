//
//  KLProfileViewController.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLProfileViewController.h"
#import "KLUserView.h"
#import "KLEventListDataSource.h"
#import "KLFollowersController.h"

@interface KLProfileViewController ()
@property (nonatomic, strong) KLUserView *header;
@end

@implementation KLProfileViewController

- (instancetype)initWithUser:(KLUserWrapper *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self layout];
    
    [self.header.userFollowersButton addTarget:self
                                        action:@selector(onFollowers)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.header.userFolowingButton addTarget:self
                                       action:@selector(onFollowings)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.header.imagePhotoButton addTarget:self
                                     action:@selector(onPhotoButton)
                           forControlEvents:UIControlEventTouchUpInside];
}

- (SFDataSource *)buildDataSource
{
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (KLUserView *)buildHeader
{
    return nil;
}

- (void)updateInfo
{
    [self.header updateWithUser:self.user];
    self.navBarTitle.text = self.user.fullName;
    [super updateInfo];
}

- (void)onFollowers
{
    KLFollowersController *followersVC = [[KLFollowersController alloc] initWithType:KLFollowUserListTypeFollowers];
    [self.navigationController pushViewController:followersVC animated:YES];
}

- (void)onFollowings
{
    KLFollowersController *followingsVC = [[KLFollowersController alloc] initWithType:KLFollowUserListTypeFollowing];
    [self.navigationController pushViewController:followingsVC animated:YES];
}

- (void)onPhotoButton
{
    if (self.user.userImage) {
        [self showPhotoViewerWithFile:self.user.userImage];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    self.navBarTitle.textColor = [UIColor colorWithWhite:0.
                                                   alpha:alpha];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48.0;
}

@end
