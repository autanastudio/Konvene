//
//  KLAccountManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLUserWrapper.h"

@interface KLAccountManager : NSObject

@property(nonatomic, strong) KLUserWrapper *currentUser;

+ (instancetype)sharedManager;

- (void)uploadUserDataToServer;
- (void)updateUserData;

- (BOOL)isCurrentUserAuthorized;
- (void)logout;

@end
