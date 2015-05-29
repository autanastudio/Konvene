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
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)kl_setNavigationBarShadowColor:(UIColor *)color
{
    UIImage *bgImage;
    if (color) {
        bgImage = [UIImage imageWithColor:color];
    } else {
        bgImage = [UIImage new];
    }
    self.navigationController.navigationBar.shadowImage = bgImage;
}

- (void)kl_setNavigationBarTitleColor:(UIColor *)color
{
    if (self.customTitleLabel) {
        self.customTitleLabel.textColor = color;
    }
}

- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
{
    self.customTitle = title;
    if (!self.customTitleLabel) {
        self.title = @"";
        self.customTitleLabel = [[UILabel alloc] init];
        [self.navigationItem setTitleView:self.customTitleLabel];
    }
    self.customTitleLabel.attributedText = [KLAttributedStringHelper stringWithFont:[UIFont helveticaNeue:SFFontStyleMedium size:16.]
                                                                              color:color
                                                                  minimumLineHeight:nil
                                                                   charecterSpacing:@0.4
                                                                             string:self.customTitle];
    [self.customTitleLabel sizeToFit];
}

- (void)kl_setBackButtonAppearanceImage:(UIImage *)image
{
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}

- (UIBarButtonItem *)kl_setBackButtonImage:(UIImage *)image
                       target:(id)target
                     selector:(SEL)selector
{
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:target
                                                                  action:selector];
    
    [self.navigationItem setLeftBarButtonItem:customItem];
    return customItem;
}

@end
