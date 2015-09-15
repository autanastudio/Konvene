//
//  SFFacebookAPI.h
//  SFKit
//
//  Created by Yarik Smirnov on 28/06/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ISFSocialAuthAPI.h"
#import "ISFSocialProfileAPI.h"
#import "ISFSocialShareAPI.h"

typedef void (^ SFFacebookAPISessionStateHandler)(FBSessionState state, NSError *error);

@interface SFFacebookAPI : NSObject <ISFSocialAuthAPI, ISFSocialProfileAPI, ISFSocialShareAPI>

@property (nonatomic, strong) SFFacebookAPISessionStateHandler stateHandler;

@end
