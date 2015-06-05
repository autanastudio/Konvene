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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    self.badge.hidden = currentInstallation.badge == 0;
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

#pragma mark - KLCreateEventControllerDelegate

- (void)dissmissCreateEventViewController:(KLCreateEventViewController *)controller
                                 newEvent:(KLEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
