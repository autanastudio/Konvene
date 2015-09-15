//
//  SFSocialManager.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 27/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFSocialManager.h"
#import "NSDictionary+SF_Additions.h"

@interface SFSocialManager ()
@property (nonatomic, strong) NSMutableDictionary *services;
@end

static SFSocialManager *g_Instance;

@implementation SFSocialManager

+ (SFSocialManager *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_Instance = [[[self class] alloc] init];
    });
    return g_Instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.services = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id<ISFSocialAuthAPI>)getAuthAPIForService:(SFSocialService)service
{
    return self.services[@(service)];
}

- (id<ISFSocialShareAPI>)getShareAPIForService:(SFSocialService)service
{
    return self.services[@(service)];
}

- (void)manageSocialAPI:(id<ISFSocialAuthAPI>)socialAPI
{
    [self.services sf_setObject:socialAPI forKey:@([socialAPI.class socialServiceType])];
}

- (void)closeServices
{
    NSArray *allSeriveces = self.services.allValues;
    [allSeriveces makeObjectsPerformSelector:@selector(closeSession)];
}

- (void)closeServicesAndClearAllCachedInfo
{
    NSArray *allSeriveces = self.services.allValues;
    [allSeriveces makeObjectsPerformSelector:@selector(closeSessionAndClearAccessData)];
}

- (BOOL)handleOpenURL:(NSURL *)openURL sourceApp:(NSString *)sourceApp
{
    NSArray *allSeriveces = self.services.allValues;
    for (id<ISFSocialAuthAPI> socialAPI in allSeriveces) {
        if ([socialAPI handleOpenURL:openURL sourceApp:sourceApp]) {
            return YES;
        }
    }
    return NO;
}


@end
