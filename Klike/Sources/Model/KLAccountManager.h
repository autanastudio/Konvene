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
extern NSString *klAccountUpdatedNotification;

typedef void(^klAccountCompletitionHandler)(BOOL succeeded, NSError *error);

@interface KLAccountManager : NSObject

@property(nonatomic, strong) KLUserWrapper *currentUser;

+ (KLAccountManager *)sharedManager;

- (void)updateCurrentUser:(PFUser *)user;
- (void)uploadUserDataToServer:(klAccountCompletitionHandler)completition;
- (void)updateUserData:(klAccountCompletitionHandler)completition;

- (void)follow:(BOOL)follow
          user:(KLUserWrapper *)user
withCompletition:(klAccountCompletitionHandler)completition;
- (PFQuery *)getFollowersQueryForUser:(KLUserWrapper *)user;
- (PFQuery *)getFollowingQueryForUser:(KLUserWrapper *)user;
- (BOOL)isFollower:(KLUserWrapper *)user;
- (BOOL)isFollowing:(KLUserWrapper *)user;

- (BOOL)isCurrentUserAuthorized;
- (void)logout;

@end
