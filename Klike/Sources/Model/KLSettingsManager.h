//
//  KLSettingsManager.h
//  Klike
//
//  Created by Alexey on 5/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLSettingsManager : NSObject

@property (nonatomic, strong) NSArray *notifications;

+ (KLSettingsManager *)sharedManager;

- (NSArray *)defaultNotifications;
- (NSArray *)notificationsTitle;

@end
