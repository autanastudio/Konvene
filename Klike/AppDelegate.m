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
#import "Stripe.h"
#import "KLSettingsManager.h"
#import "KLEventViewController.h"

static NSString *HOCKEY_APP_ID = @"92c9bd20cc7f211030770676bfccdbe0";
static NSString *klForsquareClientId = @"J4NE02UOCLIRQ2ZDB4EZ55MBPATTE302R3RDQSVZELJS2E3F";
static NSString *klForsquareClientSecret = @"DIREMPJJQBBQZVB54AZODCRRUUCRJMPPAAY2RPBDOICQZICW";

#ifdef DEBUG
static NSString *klStripePublishKey = @"pk_test_4ZGECql8uXlAP2irRMNXoWY7";
static NSString *klParseApplicationId = @"MI3UHH01oU7RrLFjgCai5l1vCZpDHRz4xuIVPmcw";
static NSString *klParseClientKey = @"Fvq2xmkw0cQB0AD3OmarcvUkQIhMPlf2hgZRtB9q";
#else
static NSString *klStripePublishKey = @"sk_live_4ZGEhsecTkKjo8xDRMvr89TA";
static NSString *klParseApplicationId = @"1V5JZTeeZ542nlDbDrq8cMYUJt34SSNDeOyUfJy8";
static NSString *klParseClientKey = @"39cpW1MC1BJNERQtB9c8SJgREsW87SQkpdjsisfG";
#endif

@interface AppDelegate ()
@property(nonatomic, strong) KLTabViewController *mainVC;
@end

@implementation AppDelegate

static AppDelegate* instance;

+ (AppDelegate*) sharedAppDelegate
{
    return instance;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    instance = self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    instance = self;
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self initializServices];
    [self initializeModelManagers];
    [self configureAppearance];
    
    self.mainVC = (KLTabViewController *)self.window.rootViewController;
    if (![[KLAccountManager sharedManager] isCurrentUserAuthorized]) {
//        self.window.rootViewController = [[KLLoginViewController alloc] init];
        self.window.rootViewController = self.mainVC;

        [self.window makeKeyAndVisible];
        [self presentLoginUIAnimated:NO];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self presentLoginUIAnimated:NO];
//        });
    } else {
        [[KLAccountManager sharedManager] updateUserData:^(BOOL succeeded, NSError *error) {
            //TODO add check
        }];
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:klAccountManagerLogoutNotification
                         withBlock:^(NSNotification *notification) {
        [weakSelf presentLoginUIAnimated:YES];
    }];
    
    return YES;
}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSString *param1 = [self valueForKey:@"eventId" fromQueryItems:queryItems];
    if (param1) {
            //
        PFQuery *eventQuery = [KLEvent query];
        [eventQuery includeKey:sf_key(owner)];
        [eventQuery includeKey:sf_key(location)];
        [eventQuery includeKey:sf_key(price)];
        [eventQuery includeKey:sf_key(extension)];
        [eventQuery includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(price), sf_key(payments)]];
        [eventQuery getObjectInBackgroundWithId:param1
                                          block:^(PFObject *object, NSError *error) {
                                              if (!error) {
                                                  
                                                  KLEventViewController *eventVC = [[KLEventViewController alloc] init];
                                                  eventVC.event = object;
//                                                  eventVC.needCloseButton = YES;
                                                  if ([self.mainVC.selectedViewController respondsToSelector:@selector(pushViewController:animated:)]) {
                                                      [((UINavigationController*)self.mainVC.selectedViewController) pushViewController:eventVC animated:YES];
                                                  }
//                                                  [self.mainVC presentViewController:eventVC
//                                                                            animated:YES
//                                                                          completion:^{
//                                                                              
//                                                                          }];
                                              }
                                          }];
        
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation kl_setObject:[[KLSettingsManager sharedManager] defaultNotifications]
                          forKey:sf_key(notifications)];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([application applicationState] != UIApplicationStateActive) {
        NSString *eventId = [userInfo objectForKey:@"eventId"];
        if (eventId && [eventId notEmpty]) {
            [self.mainVC showEventpageWithId:eventId];
        } else {
            [self.mainVC showActivityTab];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.mainVC updateBadge];
}

- (void)initializeModelManagers
{
    [Parse setApplicationId:klParseApplicationId
                  clientKey:klParseClientKey];
    [KLAccountManager sharedManager];
    [KLLoginManager sharedManager];
}

- (void)initializServices
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:HOCKEY_APP_ID];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [BITHockeyManager sharedHockeyManager].disableUpdateManager = YES;
    [Foursquare2 setupFoursquareWithClientId:klForsquareClientId
                                      secret:klForsquareClientSecret
                                 callbackURL:@""];
    [Stripe setDefaultPublishableKey:klStripePublishKey];
}

- (void)configureAppearance
{
    [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil].tintColor = [UIColor colorFromHex:0x6466ca];
    
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHex:0x1d2027]
                                                                 size:CGSizeMake(screenRect.size.width, 49.)]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor colorFromHex:0x6466ca]
                                                                         size:CGSizeMake(screenRect.size.width/5, 49.)]];
}

- (UINavigationController*)currentNavigationController
{
    return self.mainVC.selectedViewController;
}

- (void)presentLoginUIAnimated:(BOOL)animated
{
    KLLoginViewController *loginVC = [[KLLoginViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.mainVC presentViewController:navigationVC animated:animated completion:nil];
    self.mainVC.selectedIndex = 0;
    UINavigationController *nc = self.mainVC.selectedViewController;
    [nc popToRootViewControllerAnimated:YES];
}

@end
