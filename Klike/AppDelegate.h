//
//  AppDelegate.h
//  Klike
//
//  Created by Yarik Smirnov on 2/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLTabViewController;

#define ADI [AppDelegate sharedAppDelegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) KLTabViewController *mainVC;

+ (AppDelegate*)sharedAppDelegate;

- (UINavigationController*)currentNavigationController;
- (void)presentLoginUIAnimated:(BOOL)animated;

@end

