//
//  KLAccountManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *klAccountManagerLogoutNotification;
extern NSString *klAccountUpdatedNotification;

typedef void(^klCompletitionHandlerWithoutObject)(BOOL succeeded, NSError *error);

@interface KLAccountManager : NSObject

@property(nonatomic, strong) KLUserWrapper *currentUser;

+ (KLAccountManager *)sharedManager;

- (void)updateCurrentUser:(PFUser *)user;
- (void)uploadUserDataToServer:(klCompletitionHandlerWithoutObject)completition;
- (void)updateUserData:(klCompletitionHandlerWithoutObject)completition;

- (void)follow:(BOOL)follow
          user:(KLUserWrapper *)user
withCompletition:(klCompletitionHandlerWithoutObject)completition;
- (PFQuery *)getFollowersQueryForUser:(KLUserWrapper *)user;
- (PFQuery *)getFollowingQueryForUser:(KLUserWrapper *)user;
- (BOOL)isFollower:(KLUserWrapper *)user;
- (BOOL)isFollowing:(KLUserWrapper *)user;

- (BOOL)isCurrentUserAuthorized;
- (void)logout;

@end
