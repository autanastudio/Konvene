//
//  KLAccountManager.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAccountManager.h"

NSString *klAccountManagerLogoutNotification = @"klAccountManagerLogoutNotification";
NSString *klAccountUpdatedNotification = @"klAccountUpdatedNotification";

static NSString *klFollowUserCloudeFunctionName = @"follow";
static NSString *klFollowUserFollowIdKey = @"followingId";
static NSString *klFollowUserisFollowKey = @"isFollow";

@interface KLAccountManager ()
@end

@implementation KLAccountManager

+ (KLAccountManager *)sharedManager
{
    static KLAccountManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        PFUser *tempUser = [PFUser currentUser];
        if (tempUser) {
            self.currentUser = [[KLUserWrapper alloc] initWithUserObject:tempUser];
        }
    }
    return self;
}

- (void)updateCurrentUser:(PFUser *)user
{
    if (user) {
        self.currentUser = [[KLUserWrapper alloc] initWithUserObject:user];
    }
}

- (void)uploadUserDataToServer:(klCompletitionHandlerWithoutObject)completition
{
    [self.currentUser.userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completition(succeeded, error);
    }];
}

- (void)updateUserData:(klCompletitionHandlerWithoutObject)completition
{
    __weak typeof(self) weakSelf = self;
    PFQuery *updateUserQuery = [PFUser query];
    [updateUserQuery includeKey:sf_key(place)];
    [updateUserQuery getObjectInBackgroundWithId:self.currentUser.userObject.objectId
                                           block:^(PFObject *object, NSError *error) {
        if (object) {
            weakSelf.currentUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            [weakSelf postNotificationWithName:klAccountUpdatedNotification];
            completition(YES, nil);
        } else {
            completition(NO, error);
        }
    }];
}

- (BOOL)isCurrentUserAuthorized
{
    return [PFUser currentUser] != nil;
}

- (void)logout
{
    [PFUser logOut];
    self.currentUser = nil;
    [self postNotificationWithName:klAccountManagerLogoutNotification];
}

- (void)follow:(BOOL)follow
          user:(KLUserWrapper *)user
withCompletition:(klCompletitionHandlerWithoutObject)completition
{
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:klFollowUserCloudeFunctionName
                       withParameters:@{ klFollowUserFollowIdKey : user.userObject.objectId ,
                                         klFollowUserisFollowKey : [NSNumber numberWithBool:follow]}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        weakSelf.currentUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
                                        completition(YES, nil);
                                    } else {
                                        completition(NO, error);
                                    }
                                }];
}

- (PFQuery *)getFollowersQueryForUser:(KLUserWrapper *)user
{
    if (!user) {
        user = self.currentUser;
    }
    PFQuery *userListQuery = [PFUser query];
    [userListQuery whereKey:sf_key(objectId)
                containedIn:user.followers];
    return userListQuery;
}

- (PFQuery *)getFollowingQueryForUser:(KLUserWrapper *)user
{
    if (!user) {
        user = self.currentUser;
    }
    PFQuery *userListQuery = [PFUser query];
    [userListQuery whereKey:sf_key(objectId)
                containedIn:user.following];
    return userListQuery;
}

- (BOOL)isOwnerOfEvent:(KLEvent *)event
{
    return [self.currentUser.userObject.objectId isEqualToString:event.owner.objectId];
}

- (BOOL)isFollower:(KLUserWrapper *)user
{
    if (user == self.currentUser) {
        return NO;
    }
    return [self.currentUser.followers indexOfObject:user.userObject.objectId]!=NSNotFound;
}

- (BOOL)isFollowing:(KLUserWrapper *)user
{
    if (user == self.currentUser) {
        return NO;
    }
    return [self.currentUser.following indexOfObject:user.userObject.objectId]!=NSNotFound;
}

@end
