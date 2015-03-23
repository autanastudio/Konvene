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
#import "KLAccountManager.h"
#import "KLLoginManager.h"

static NSString *HOCKEY_APP_ID = @"92c9bd20cc7f211030770676bfccdbe0";
static NSString *klParseApplicationId = @"1V5JZTeeZ542nlDbDrq8cMYUJt34SSNDeOyUfJy8";
static NSString *klParseClientKey = @"39cpW1MC1BJNERQtB9c8SJgREsW87SQkpdjsisfG";
static NSString *klForsquareClientId = @"J4NE02UOCLIRQ2ZDB4EZ55MBPATTE302R3RDQSVZELJS2E3F";
static NSString *klForsquareClientSecret = @"DIREMPJJQBBQZVB54AZODCRRUUCRJMPPAAY2RPBDOICQZICW";

@interface AppDelegate ()
@property(nonatomic, strong) KLTabViewController *mainVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initializeHockeyApp];
    [self initializeModelManagers];
    [self initializeSocialNetworks];
    [self configureAppearance];
    
    self.mainVC = (KLTabViewController *)self.window.rootViewController;
    if (![[KLAccountManager sharedManager] isCurrentUserAuthorized]) {
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
    [Parse enableLocalDatastore];
    [Parse setApplicationId:klParseApplicationId
                  clientKey:klParseClientKey];
    [[KLAccountManager sharedManager] logout];//TODO
    [KLLoginManager sharedManager];
}

- (void)initializeSocialNetworks
{
    [Foursquare2 setupFoursquareWithClientId:klForsquareClientId
                                      secret:klForsquareClientSecret
                                 callbackURL:@""];
}

- (void)configureAppearance
{
    [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil].tintColor = [UIColor colorFromHex:0x6466ca];
}

- (void)presentLoginUIanimated:(BOOL)animated
{
    KLLoginViewController *loginVC = [[KLLoginViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.mainVC presentViewController:navigationVC animated:animated completion:nil];
}

@end
