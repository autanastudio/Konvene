//
//  UIViewController+KL_Additions.h
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLChildrenViewControllerDelegate <NSObject>
- (void)viewController:(UIViewController *)viewController
      dissmissAnimated:(BOOL)animated;
@end

@interface UIViewController (KL_Additions)

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UINavigationItem *customNavigationItem;

- (void)kl_setNavigationBarColor:(UIColor *)color;
- (void)kl_setNavigationBarShadowColor:(UIColor *)color;
- (void)kl_setNavigationBarTitleColor:(UIColor *)color;
- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
            spacing:(NSNumber *)spacing;
- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
            spacing:(NSNumber *)spacing
              inset:(UIEdgeInsets)inset;
- (void)kl_setBackButtonAppearanceImage:(UIImage *)image;
- (UIBarButtonItem *)kl_setBackButtonImage:(UIImage *)image
                       target:(id)target
                     selector:(SEL)selector;
- (UINavigationItem *)currentNavigationItem;
- (UINavigationBar *)currentNavigationBar;

@end
