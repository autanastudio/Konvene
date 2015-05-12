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
@property (nonatomic, strong) UIBarButtonItem *backButton;
@end

@implementation KLMyProfileViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needBackButton = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.needBackButton = NO;
    }
    return self;
}

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
    
    if (self.needBackButton) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(onBack)];
        self.backButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = self.backButton;
    }
}

- (SFDataSource *)buildDataSource
{
    KLEventListDataSource *dataSource = [[KLEventListDataSource alloc] init];
    dataSource.user = self.user;
    dataSource.type = KLEventListDataSourceTypeCreated;
    dataSource.listDelegate = self;
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

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
