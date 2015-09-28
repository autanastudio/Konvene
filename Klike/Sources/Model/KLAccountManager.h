//
//  KLAccountManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *klAccountManagerLogoutNotification;
extern NSString *klAccountManagerLoginNotification;
extern NSString *klAccountUpdatedNotification;

@interface KLAccountManager : NSObject

@property(nonatomic, strong) KLUserWrapper *currentUser;

+ (KLAccountManager *)sharedManager;

- (void)updateCurrentUser:(PFUser *)user;
- (void)uploadUserDataToServer:(klCompletitionHandlerWithoutObject)completition;
- (void)updateUserData:(klCompletitionHandlerWithoutObject)completition;
- (void)deleteUser:(klCompletitionHandlerWithoutObject)completition;
- (void)assocVenmoInfo:(NSString *)accessToken refreshToken:(NSString *)refreshToken username:(NSString *)username andUserID:(NSString *)userID withCompletion:(klCompletitionHandlerWithoutObject)completion;
- (void)follow:(BOOL)follow
          user:(KLUserWrapper *)user
withCompletition:(klCompletitionHandlerWithoutObject)completition;
- (PFQuery *)getFollowersQueryForUser:(KLUserWrapper *)user;
- (PFQuery *)getFollowingQueryForUser:(KLUserWrapper *)user;
- (BOOL)isFollower:(KLUserWrapper *)user;
- (BOOL)isFollowing:(KLUserWrapper *)user;

- (BOOL)isCurrentUserAuthorized;
- (BOOL)isOwnerOfEvent:(KLEvent *)event;
- (void)logout;

@end
