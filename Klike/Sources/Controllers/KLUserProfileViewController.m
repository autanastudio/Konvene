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
#import "KLInviteFriendsViewController.h"

@interface KLSrollViewWithTable : UIScrollView
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation KLSrollViewWithTable

- (BOOL)touchesShouldBegin:(NSSet *)touches
                 withEvent:(UIEvent *)event
             inContentView:(UIView *)view
{
    if ([view isEqual:self.tableView]) {
        return YES;
    } else {
        return [super touchesShouldBegin:touches
                               withEvent:event
                           inContentView:view];
    }
}

@end

@interface KLUserProfileViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) KLUserWrapper *user;
@property (nonatomic, strong) KLSrollViewWithTable *scrollView;
@property (nonatomic, strong) KLUserView *userView;
@end

@implementation KLUserProfileViewController

- (instancetype)initWithUser:(KLUserWrapper *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.userView = [self buildUserView];
    self.scrollView = [[KLSrollViewWithTable alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.userView];
    self.scrollView.tableView = self.userView.tableView;
    self.scrollView.delegate = self;
    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.userView configureWithRootView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:nil];
    
    UIImage *settingButtonImage = [[UIImage imageNamed:@"profile_ic_top"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:settingButtonImage
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(onSettings)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] updateUserData:^(BOOL succeeded, NSError *error) {
        weakSelf.user = [KLAccountManager sharedManager].currentUser;
        [weakSelf.userView updateWithUser:weakSelf.user];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (KLUserView *)buildUserView
{
    UINib *nib = [UINib nibWithNibName:@"KLUserProfileView" bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (void)onSettings
{
    [self.navigationController pushViewController:[[KLInviteFriendsViewController alloc] initForType:KLInviteTypeFriends] animated:YES];
//    [[KLAccountManager sharedManager] logout];
}

#pragma mark - UIScrollViewDelegate methods

@end
