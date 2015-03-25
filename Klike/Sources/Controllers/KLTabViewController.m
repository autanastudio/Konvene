//
//  KLTabViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTabViewController.h"

@interface KLTabViewController ()

@end

static CGFloat klTabItemOffset = 5.;

@implementation KLTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
