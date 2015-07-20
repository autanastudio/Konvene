//
//  KLTabViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTabViewController.h"
#import "KLCreateEventViewController.h"
#import "KLExploreController.h"
#import "KLEventViewController.h"
#import "KLUserProfileViewController.h"
#import <CustomIOSAlertView/CustomIOSAlertView.h>

typedef enum : NSUInteger {
    KLTabControllerTypeExplore,
    KLTabControllerTypeMyEvent,
    KLTabControllerTypeCreate,
    KLTabControllerTypeActivity,
    KLTabControllerTypeProfile
} KLTabControllerType;

@interface KLTabViewController () <UITabBarControllerDelegate, KLCreateEventDelegate>

@property (nonatomic, strong) UIImageView *badge;

@end

static CGFloat klTabItemOffset = 5.;

@implementation KLTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self addCreateButton];
    NSArray *selectedImages = @[[UIImage imageNamed:@"ic_tabbar_1"],
                                [UIImage imageNamed:@"ic_tabbar_2_act"],
                                [UIImage imageNamed:@"ic_create_event"],
                                [UIImage imageNamed:@"ic_tabbar_4_act"],
                                [UIImage imageNamed:@"ic_tabbar_5_act"],];
    for (UITabBarItem *tabItem in self.tabBar.items) {
        tabItem.image = [tabItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem.selectedImage = selectedImages[tabItem.tag];
        tabItem.imageInsets = UIEdgeInsetsMake(klTabItemOffset, 0, -klTabItemOffset, 0);
    }
    [self addBadge];
}

- (void)updateBadge
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    self.badge.hidden = currentInstallation.badge == 0 && ![currentUser.invited boolValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBadge];
}

- (void)addBadge
{
    self.badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notify"]];
    CGFloat width = self.tabBar.frame.size.width / 5;
    //magic number for proportion =)
    CGRect frame = CGRectMake(width*3+width*0.5234, 10, 9, 9);
    self.badge.frame = frame;
    self.badge.hidden = YES;
    [self.tabBar addSubview:self.badge];
}

- (void)addCreateButton
{
    CGFloat width = self.tabBar.frame.size.width / 5;
    CGFloat height = self.tabBar.frame.size.height;
    UIButton *createButtton = [[UIButton alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
    [self.tabBar addSubview:createButtton];
}

- (void)presentCreateController
{
    KLCreateEventViewController *createController = [[KLCreateEventViewController alloc] init];
    createController.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:createController];
    [self presentViewController:navVC animated:YES completion:^{
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == KLTabControllerTypeCreate) {
        [self presentCreateController];
        return NO;
    } else if (index == KLTabControllerTypeExplore) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)viewController;
            if ([navVC.viewControllers.lastObject isKindOfClass:[KLExploreController class]]) {
                KLExploreController *exploreController = (KLExploreController *)navVC.viewControllers.lastObject;
                [exploreController scrollToTop];
            }
        }
    } else if (index == KLTabControllerTypeActivity) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            [currentInstallation saveEventually];
        }
        self.badge.hidden = YES;
    }
    return YES;
}

- (void)showActivityTab
{
    self.selectedIndex = KLTabControllerTypeActivity;
}

- (void)showEventpageWithId:(NSString *)eventId
{
    self.selectedIndex = KLTabControllerTypeActivity;
    UINavigationController *activityController = (UINavigationController *)self.selectedViewController;
    KLEvent *event = [KLEvent objectWithoutDataWithObjectId:eventId];
    [event fetch];
    if (event) {
        KLEventViewController *eventVC = [[KLEventViewController alloc] initWithEvent:event];
        eventVC.animated = NO;
        [activityController pushViewController:eventVC
                                      animated:YES];
    }
}

- (void)showUserPageWithId:(NSString *)userId
{
    self.selectedIndex = KLTabControllerTypeActivity;
    UINavigationController *activityController = (UINavigationController *)self.selectedViewController;
    PFUser *user = [PFUser user];
    user.objectId = userId;
    [user fetch];
    if (user) {
        KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:user];
        KLUserProfileViewController *userProfileVC = [[KLUserProfileViewController alloc] initWithUser:userWrapper];
        [activityController pushViewController:userProfileVC
                                             animated:YES];
    }
}

- (void)showAlertviewWithMessage:(NSString *)message
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIView *alertContainer = [[UIView alloc] init];
    alertContainer.backgroundColor = [UIColor clearColor];
    
    UIImageView *alertIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_alert-1"]];
    [alertIcon autoSetDimensionsToSize:alertIcon.frame.size];
    [alertContainer addSubview:alertIcon];
    
    UILabel *alertMessage = [[UILabel alloc] init];
    alertMessage.lineBreakMode = NSLineBreakByWordWrapping;
    alertMessage.numberOfLines = 0;
    alertMessage.text = message;
    alertMessage.font = [UIFont helveticaNeue:SFFontStyleMedium
                                         size:17.];
    alertMessage.textColor = [UIColor blackColor];
    [alertContainer addSubview:alertMessage];
    
    [alertIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:24.];
    [alertIcon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [alertIcon autoPinEdge:ALEdgeBottom
                    toEdge:ALEdgeTop
                    ofView:alertMessage
                withOffset:-16.];
    
    [alertMessage autoSetDimension:ALDimensionWidth
                            toSize:screenSize.width-50.-48.];
    [alertMessage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0., 24., 24., 24.)
                                           excludingEdge:ALEdgeTop];
    
    CGRect tempFrame = alertContainer.frame;
    CGSize tempSize = [alertContainer systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    tempFrame.size = tempSize;
    alertContainer.frame = tempFrame;
    
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    alert.containerView = alertContainer;
    alert.buttonTitles = @[@"OK"];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    [alert show];
}

#pragma mark - KLCreateEventControllerDelegate

- (void)dissmissCreateEventViewController:(KLCreateEventViewController *)controller
                                 newEvent:(KLEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
