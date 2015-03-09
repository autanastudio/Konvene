//
//  UIViewController+KL_Additions.m
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "UIViewController+KL_Additions.h"

@implementation UIViewController (KL_Additions)

- (void)kl_setNavigationBarColor:(UIColor *)color
{
    UIImage *bgImage;
    if (color) {
        bgImage = [UIImage imageWithColor:color];
    } else {
        bgImage = [UIImage new];
    }
    [self.navigationController.navigationBar setBackgroundImage:bgImage
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = bgImage; //[UIImage new];
    self.navigationController.navigationBar.translucent = color ? NO : YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)kl_setNavigationBarTitleColor:(UIColor *)color
{
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         color,
                                         NSForegroundColorAttributeName,
                                         [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                          style:SFFontStyleMedium
                                                           size:16.],
                                         NSFontAttributeName,
                                         nil];
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    self.navigationController.navigationBar.tintColor = color;
}

@end
