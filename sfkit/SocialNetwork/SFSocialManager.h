//
//  SFSocialManager.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 27/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISFSocialAuthAPI.h"
#import "ISFSocialShareAPI.h"

@interface SFSocialManager : NSObject

+ (SFSocialManager *)instance;

- (void)manageSocialAPI:(id<ISFSocialAuthAPI>)socialAPI;

- (id<ISFSocialAuthAPI>)getAuthAPIForService:(SFSocialService)service;

- (id<ISFSocialShareAPI>)getShareAPIForService:(SFSocialService)service;

- (void)closeServices;

- (void)closeServicesAndClearAllCachedInfo;

- (BOOL)handleOpenURL:(NSURL *)openURL sourceApp:(NSString *)sourceApp;

@end
