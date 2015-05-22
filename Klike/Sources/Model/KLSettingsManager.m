//
//  KLSettingsManager.m
//  Klike
//
//  Created by Alexey on 5/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSettingsManager.h"

@implementation KLSettingsManager

+ (KLSettingsManager *)sharedManager
{
    static KLSettingsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSArray *)notifications
{
    PFInstallation *currentInstall = [PFInstallation currentInstallation];
    NSArray *result = currentInstall[sf_key(notifications)];
    if (!result) {
        result = [self defaultNotifications];
    }
    return result;
}

- (void)setNotifications:(NSArray *)notifications
{
    PFInstallation *currentInstall = [PFInstallation currentInstallation];
    [currentInstall kl_setObject:notifications
                          forKey:sf_key(notifications)];
    [currentInstall saveInBackground];
}

- (NSArray *)defaultNotifications
{
    NSArray *array = @[     @(KLActivityTypeFollowMe),
                            @(KLActivityTypeFollow),
                            @(KLActivityTypeCreateEvent),
                            @(KLActivityTypeGoesToEvent),
                            @(KLActivityTypeGoesToMyEvent),
                            @(KLActivityTypeEventCanceled),
                            @(KLActivityTypeEventChangedName),
                            @(KLActivityTypeEventChangedLocation),
                            @(KLActivityTypeEventChangedTime),
                            @(KLActivityTypePhotosAdded),
                            @(KLActivityTypeCommentAdded),
                            @(KLActivityTypePayForEvent)];
    return array;
}

- (NSArray *)notificationsTitle
{
    NSArray *array = @[@"I have a new follower",
                       @"The person, I follow, starts following someone",
                       @"The person, I follow, creates an event",
                       @"The person, I follow, goes to an event",
                       @"Someone goes to my event",
                       @"Event is canceled",
                       @"Event's details changed",
                       @"Event's details changed",
                       @"Event's details changed",
                       @"Photo is added to my event",
                       @"Comment is added to my event",
                       @"Someone pays into my event"];
    return array;
}

@end
