//
//  UIViewController+KL_Additions.h
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KL_Additions)

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

- (void)kl_setNavigationBarColor:(UIColor *)color;
- (void)kl_setNavigationBarTitleColor:(UIColor *)color;
- (void)kl_setTitle:(NSString *)title;
- (void)kl_setBackButtonImage:(UIImage *)image;

@end
