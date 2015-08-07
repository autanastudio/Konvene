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
@dynamic customNavigationItem;
@dynamic navigationBar;

- (void)kl_setNavigationBarColor:(UIColor *)color
{
    UIImage *bgImage;
    if (color) {
        bgImage = [UIImage imageWithColor:color];
    } else {
        bgImage = [UIImage new];
    }
    [self.currentNavigationBar setBackgroundImage:bgImage
                                                  forBarMetrics:UIBarMetricsDefault];
    self.currentNavigationBar.shadowImage = bgImage;
    self.currentNavigationBar.translucent = color ? NO : YES;
}

- (UINavigationItem *)currentNavigationItem
{
    return self.navigationItem;
}

- (UINavigationBar *)currentNavigationBar
{
    return self.navigationController.navigationBar;
}

- (void)kl_setNavigationBarShadowColor:(UIColor *)color
{
    UIImage *bgImage;
    if (color) {
        bgImage = [UIImage imageWithColor:color];
    } else {
        bgImage = [UIImage new];
    }
    self.currentNavigationBar.shadowImage = bgImage;
}

- (void)kl_setNavigationBarTitleColor:(UIColor *)color
{
    if (self.customTitleLabel) {
        self.customTitleLabel.textColor = color;
    }
}

- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
            spacing:(NSNumber *)spacing
              inset:(UIEdgeInsets)inset
{
    self.customTitle = title;
    if (!self.customTitleLabel) {
        self.title = @"";
        self.customTitleLabel = [[UILabel alloc] init];
        UIView *container = [[UIView alloc] init];
        [container addSubview:self.customTitleLabel];
        NSLayoutConstraint *temp = [self.customTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        temp.constant = inset.left;
        temp = [self.customTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        temp.constant = inset.top;
        [self.currentNavigationItem setTitleView:container];
    }
    self.customTitleLabel.attributedText = [KLAttributedStringHelper stringWithFont:[UIFont helveticaNeue:SFFontStyleMedium size:16.]
                                                                              color:color
                                                                  minimumLineHeight:nil
                                                                   charecterSpacing:spacing
                                                                             string:self.customTitle];
    [self.customTitleLabel sizeToFit];
}

- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
            spacing:(NSNumber *)spacing
{
    self.customTitle = title;
    if (!self.customTitleLabel) {
        self.title = @"";
        self.customTitleLabel = [[UILabel alloc] init];
        [self.currentNavigationItem setTitleView:self.customTitleLabel];
    }
    self.customTitleLabel.attributedText = [KLAttributedStringHelper stringWithFont:[UIFont helveticaNeue:SFFontStyleMedium size:16.]
                                                                              color:color
                                                                  minimumLineHeight:nil
                                                                   charecterSpacing:spacing
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
    
    [self.currentNavigationItem setLeftBarButtonItem:customItem];
    return customItem;
}

@end
