//
//  AppDelegate.m
//  Klike
//
//  Created by Yarik Smirnov on 2/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <HockeySDK/HockeySDK.h>

static NSString *HOCKEY_APP_ID = @"92c9bd20cc7f211030770676bfccdbe0";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initializeHockeyApp];
    
    return YES;
}

- (void)initializeHockeyApp
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:HOCKEY_APP_ID];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [BITHockeyManager sharedHockeyManager].updateManager.showDirectInstallOption = YES;
}


@end
