//
//  UINavigationController+StatusBarAppearence.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 22/10/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "UINavigationController+StatusBarAppearence.h"

@implementation UINavigationController (StatusBarAppearence)

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
