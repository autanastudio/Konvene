//
//  KLMyProfileViewController.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLMyProfileViewController.h"
#import "KLEventListDataSource.h"

@interface KLMyProfileViewController ()
@property (nonatomic, strong) UIBarButtonItem *settingsButton;
@end

@implementation KLMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        if (succeeded) {
            weakSelf.user = [KLAccountManager sharedManager].currentUser;
            [weakSelf updateInfo];
        }
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

- (void)onSettings
{
    [[KLAccountManager sharedManager] logout];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.settingsButton.tintColor = navBarElementsColor;
}

- (UIView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"MyProfileView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

@end
