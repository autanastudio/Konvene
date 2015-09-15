//
//  UINavigationBar+SF_Additions.m
//  Livid
//
//  Created by Yarik Smirnov on 12/25/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import "UINavigationController+SF_Additions.h"
#import <objc/runtime.h>

static void * SFNavigationBarTintColorKey = @"SFNavigationBarTintColorKey";
static void * SFNavigationBarBackgroundHiddenFlagKey = @"SFNavigationBarBackgroundHiddenFlagKey";

@implementation UINavigationController (SF_Additions)

- (void)setBackgroundHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.navigationBar.translucent = hidden;
    UIColor *barTintColor = nil;
    if (hidden) {
        NSNumber *flag = objc_getAssociatedObject(self.navigationBar, SFNavigationBarBackgroundHiddenFlagKey);
        if (!flag.boolValue) {
            barTintColor = self.navigationBar.barTintColor;
            objc_setAssociatedObject(self.navigationBar,
                                     SFNavigationBarTintColorKey,
                                     self.navigationBar.barTintColor,
                                     OBJC_ASSOCIATION_RETAIN);
            objc_setAssociatedObject(self.navigationBar,
                                     SFNavigationBarBackgroundHiddenFlagKey,
                                     @YES,
                                     OBJC_ASSOCIATION_RETAIN);
            self.navigationBar.barTintColor = nil;
            [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navigationBar.shadowImage = [UIImage new];
        }
    } else {
        UIColor *barTintColor = objc_getAssociatedObject(self.navigationBar, SFNavigationBarTintColorKey);
        objc_setAssociatedObject(self.navigationBar, SFNavigationBarTintColorKey, nil, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self.navigationBar,
                                 SFNavigationBarBackgroundHiddenFlagKey,
                                 nil,
                                 OBJC_ASSOCIATION_RETAIN);
        self.navigationBar.barTintColor = barTintColor;
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = nil;
    }
    if (animated && hidden) {
        UIView *fakeBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        [self.view insertSubview:fakeBG belowSubview:self.navigationBar];
        fakeBG.backgroundColor = barTintColor;
        fakeBG.alpha = (CGFloat)hidden;
        [UIView animateWithDuration:.6
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             fakeBG.alpha = (CGFloat)!hidden;
                         } completion:^(BOOL finished) {
                             [fakeBG removeFromSuperview];
                         }];
    }
}

@end
