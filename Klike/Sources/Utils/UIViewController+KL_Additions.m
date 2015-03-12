//
//  UIViewController+KL_Additions.m
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "UIViewController+KL_Additions.h"

@implementation UIViewController (KL_Additions)

@dynamic customTitleLabel;
@dynamic customTitle;

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
    self.navigationController.navigationBar.shadowImage = bgImage;
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
    if (self.customTitleLabel) {
        self.customTitleLabel.textColor = color;
    }
}

- (void)kl_setTitle:(NSString *)title
{
    if (!self.customTitleLabel) {
        self.title = @"";
        self.customTitleLabel = [[UILabel alloc] init];
        [self.customTitleLabel setText:self.customTitle];
        [self.customTitleLabel setTextColor:[UIColor whiteColor]];
        [self.customTitleLabel setFont:[UIFont systemFontOfSize:17.]];
        [self.navigationItem setTitleView:self.customTitleLabel];
    }
    self.customTitle = title;
    [self.customTitleLabel setText:self.customTitle];
    [self.customTitleLabel sizeToFit];
}

- (void)kl_setBackButtonImage:(UIImage *)image
{
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}

@end
