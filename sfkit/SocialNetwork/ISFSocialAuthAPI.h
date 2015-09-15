//
//  ISFSocialAuthAPI.h
//  SFKit
//
//  Created by Yarik Smirnov on 28/06/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SFSocialService) {
    SFSocialServiceFacebook,
    SFSocialServiceTwitter,
    SFSocialServiceInstgram,
};

@class SFAccessData;
typedef void (^ SFSocialAuthorizationHandler)(BOOL authorized, NSError *error);
typedef void (^ SFSocialAuthorizationParamsHandler)(NSDictionary *params, NSError *error);

@protocol ISFSocialAuthAPI <NSObject>

+ (SFSocialService)socialServiceType;

- (void)loadCachedAuthorizationForScope:(NSArray *)scope;

- (void)isAuthorizedForScope:(NSArray *)scope completionHandler:(SFSocialAuthorizationHandler)handler;

- (void)openSession:(SFSocialAuthorizationHandler)completion;

- (void)openSessionForScope:(NSArray *)scope completion:(SFSocialAuthorizationHandler)handler;

- (void)requestAuthorizationForScope:(NSArray *)scope completion:(SFSocialAuthorizationHandler)handler;

- (BOOL)isAuthorized;

- (void)closeSessionAndClearAccessData;

- (void)closeSession;

- (void)getAuthorizationParams:(SFSocialAuthorizationParamsHandler)completion;

- (void)handleAppBecomeActive;

- (BOOL)handleOpenURL:(NSURL *)openURL sourceApp:(NSString *)appID;

@end
