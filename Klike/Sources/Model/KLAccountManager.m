//
//  KLAccountManager.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAccountManager.h"
#import "AppDelegate.h"
#import "KLTabViewController.h"
#import "KLOperationManager.h"
#import "KLVenmoInfo.h"

NSString *klAccountManagerLogoutNotification = @"klAccountManagerLogoutNotification";
NSString *klAccountManagerLoginNotification = @"klAccountManagerLoginNotification";
NSString *klAccountUpdatedNotification = @"klAccountUpdatedNotification";

static NSString *klFollowUserCloudeFunctionName = @"follow";
static NSString *klAddCardCloudeFunctionName = @"addCard";
static NSString *klAuthWithStripeConnect = @"authStripeConnect";
static NSString *klAssociateVenmoInfo = @"assocVenmoInfo";
static NSString *klAccessTokenKey = @"accessToken";
static NSString *klRefreshTokenKey = @"refreshToken";
static NSString *klUserIDKey = @"userID";
static NSString *klUsernameKey = @"username";
static NSString *klVenmoInfoIDKey = @"venmoInfoID";
static NSString *klDeleteCardCloudeFunctionName = @"deleteCard";
static NSString *klDeleteUserCloudeFunctionName = @"deleteUser";
static NSString *klCardTokenKey = @"token";
static NSString *klCardIdKey = @"cardId";
static NSString *klCodeKey = @"code";
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
    [updateUserQuery includeKey:sf_key(venmoInfo)];
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

- (void)deleteUser:(klCompletitionHandlerWithoutObject)completition
{
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:klDeleteUserCloudeFunctionName
                       withParameters:nil
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        [weakSelf updateCurrentUser:object];
                                        completition(YES, nil);
                                    } else {
                                        completition(NO, error);
                                    }
                                }];
}

- (void)assocVenmoInfo:(NSString *)accessToken refreshToken:(NSString *)refreshToken username:(NSString *)username andUserID:(NSString *)userID
        withCompletion:(klCompletitionHandlerWithoutObject)completion
{
    [PFCloud callFunctionInBackground:klAssociateVenmoInfo withParameters:@{klAccessTokenKey: accessToken, klRefreshTokenKey: refreshToken, klUsernameKey: username, klUserIDKey: userID} block:^(id  _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSData *data = [(NSString *)object dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *descriptionDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *objectID = descriptionDict[klVenmoInfoIDKey];
            KLVenmoInfo *info = [KLVenmoInfo venmoInfoWithoutDataWithId:objectID];
            [KLAccountManager sharedManager].currentUser.userObject[sf_key(venmoInfo)] = info;

            completion(YES, nil);
        } else {
            completion(NO, error);
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
    KLOperationManager *manager = [KLOperationManager sharedManager];
    NSBlockOperation *followOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error;
        PFObject *object = [PFCloud callFunction:klFollowUserCloudeFunctionName
                                  withParameters:@{ klFollowUserFollowIdKey : user.userObject.objectId ,
                                                    klFollowUserisFollowKey : [NSNumber numberWithBool:follow]}
                                           error:&error];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!error) {
                weakSelf.currentUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
                completition(YES, nil);
            } else {
                completition(NO, error);
                NSString *message = [NSString stringWithFormat:@"Sorry, server has not responded on time, so you couldn't start %@ %@. Please try again.",follow ? @"following" : @"unfollowing", user.fullName];
                [ADI.mainVC showAlertviewWithMessage:message];
            }
        }];
    }];
    [manager addFollowOperationToQueue:followOperation];
}

- (PFQuery *)getFollowersQueryForUser:(KLUserWrapper *)user
{
    if (!user) {
        user = self.currentUser;
    }
    PFQuery *userListQuery = [PFUser query];
    [userListQuery whereKey:sf_key(objectId)
                containedIn:user.followers];
    [userListQuery orderByAscending:sf_key(fullName)];
    [userListQuery whereKey:sf_key(isRegistered) equalTo:@(YES)];
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
    [userListQuery orderByAscending:sf_key(fullName)];
    [userListQuery whereKey:sf_key(isRegistered) equalTo:@(YES)];
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
