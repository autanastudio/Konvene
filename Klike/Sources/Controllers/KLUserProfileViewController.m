//
//  KLUserProfileViewController.m
//  Klike
//
//  Created by admin on 25/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserProfileViewController.h"
#import "KLUserWrapper.h"
#import "KLAccountManager.h"
#import "KLUserView.h"
#import "KLEventListDataSource.h"
#import "KLFollowersController.h"

@interface KLUserProfileViewController ()
@property (nonatomic, strong) KLUserView *header;
@property (nonatomic, strong) KLUserWrapper *user;
@property (nonatomic, strong) UIBarButtonItem *settingsButton;
@property (nonatomic, strong) UIView *sectionHeaderView;
@end

@implementation KLUserProfileViewController

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
    
    self.settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_ic_top"]
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(onSettings)];
    self.navigationItem.rightBarButtonItem = self.settingsButton;
    
    self.sectionHeaderView = [[UIView alloc] init];
    self.sectionHeaderView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    UILabel *headetTitle = [[UILabel alloc] init];
    headetTitle.text = SFLocalized(@"profile.createdevents.title");
    headetTitle.font = [UIFont helveticaNeue:SFFontStyleMedium size:12.];
    headetTitle.textColor = [UIColor blackColor];
    [self.sectionHeaderView addSubview:headetTitle];
    [headetTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [headetTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] updateUserData:^(BOOL succeeded, NSError *error) {
        weakSelf.user = [KLAccountManager sharedManager].currentUser;
        [weakSelf updateInfo];
    }];
    
}

- (SFDataSource *)buildDataSource
{
    PFQuery *query = [KLEvent query];
    query.limit = 5;
    [query includeKey:sf_key(location)];
    KLEventListDataSource *dataSource = [[KLEventListDataSource alloc] initWithQuery:query];
    return dataSource;
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
    UINib *nib = [UINib nibWithNibName:@"KLUserProfileView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)updateInfo
{
    [self.header updateWithUser:self.user];
    self.navBarTitle.text = self.user.fullName;
    [super updateInfo];
}

- (void)onSettings
{
    [[KLAccountManager sharedManager] logout];
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
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.navBarTitle.textColor = [UIColor colorWithWhite:0.
                                                   alpha:alpha];
    self.settingsButton.tintColor = navBarElementsColor;
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
