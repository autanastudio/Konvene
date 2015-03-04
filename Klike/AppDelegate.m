//
//  AppDelegate.m
//  Klike
//
//  Created by Yarik Smirnov on 2/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <HockeySDK/HockeySDK.h>
#import "KLLoginViewController.h"
#import "KLTabViewController.h"

static NSString *HOCKEY_APP_ID = @"92c9bd20cc7f211030770676bfccdbe0";

@interface AppDelegate ()
@property(nonatomic, strong) KLTabViewController *mainVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initializeHockeyApp];
    [self initializeModelManagers];
    
    self.mainVC = (KLTabViewController *)self.window.rootViewController;
    //TODO replace with real auth check
    if (YES) {
        self.window.rootViewController = [[KLLoginViewController alloc] init];
        [self.window makeKeyAndVisible];
        self.window.rootViewController = self.mainVC;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentLoginUIanimated:NO];
        });
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    return YES;
}

- (void)initializeHockeyApp
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:HOCKEY_APP_ID];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [BITHockeyManager sharedHockeyManager].updateManager.showDirectInstallOption = YES;
}

- (void)initializeModelManagers
{
    
}

- (void)presentLoginUIanimated:(BOOL)animated
{
    KLLoginViewController *loginVC = [[KLLoginViewController alloc] init];
    [self.mainVC presentViewController:loginVC animated:animated completion:nil];
}


@end
