//
//  KLTabViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTabViewController.h"
#import "KLCreateEventViewController.h"

@interface KLTabViewController () <UITabBarControllerDelegate>

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
                                [UIImage imageNamed:@"ic_tabbar_3"],
                                [UIImage imageNamed:@"ic_tabbar_4_act"],
                                [UIImage imageNamed:@"ic_tabbar_5_act"],];
    for (UITabBarItem *tabItem in self.tabBar.items) {
        tabItem.image = [tabItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem.selectedImage = selectedImages[tabItem.tag];
        tabItem.imageInsets = UIEdgeInsetsMake(klTabItemOffset, 0, -klTabItemOffset, 0);
    }
}

- (void)addCreateButton
{
    CGFloat width = self.tabBar.frame.size.width / 5;
    CGFloat height = self.tabBar.frame.size.height;
    UIButton *createButtton = [[UIButton alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
    [createButtton setImage:[UIImage imageNamed:@"ic_tabbar_3"]
                   forState:UIControlStateNormal];
    [self.tabBar addSubview:createButtton];
}

- (void)presentCreateController
{
    //TODO add delegate for hide
    KLCreateEventViewController *createController = [[KLCreateEventViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:createController];
    [self presentViewController:navVC animated:YES completion:^{
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 2) {
        [self presentCreateController];
        return NO;
    }
    return YES;
}

@end
