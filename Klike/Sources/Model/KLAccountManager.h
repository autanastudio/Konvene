//
//  KLAccountManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLUserWrapper.h"

extern NSString *klAccountManagerLogoutNotification;

typedef void(^klAccountCompletitionhandler)(BOOL succeeded, NSError *error);

@interface KLAccountManager : NSObject

@property(nonatomic, strong) KLUserWrapper *currentUser;

+ (instancetype)sharedManager;

- (void)updateCurrentUser:(PFUser *)user;
- (void)uploadUserDataToServer:(klAccountCompletitionhandler)completition;
- (void)updateUserData:(klAccountCompletitionhandler)completition;

- (BOOL)isCurrentUserAuthorized;
- (void)logout;

@end
