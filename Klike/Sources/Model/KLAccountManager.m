//
//  KLAccountManager.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAccountManager.h"

NSString *klAccountManagerLogoutNotification = @"klAccountManagerLogoutNotification";

static NSString *klFollowActionKey = @"FollowAction";
static NSString *klFollowActionFromKey = @"from";
static NSString *klFollowActionToKey = @"to";

@interface KLAccountManager ()
@end

@implementation KLAccountManager

+ (instancetype)sharedManager {
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

- (void)uploadUserDataToServer:(klAccountCompletitionHandler)completition
{
    [self.currentUser.userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completition(succeeded, error);
    }];
}

- (void)updateUserData:(klAccountCompletitionHandler)completition
{
    __weak typeof(self) weakSelf = self;
    [self.currentUser.userObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            weakSelf.currentUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            [weakSelf.currentUser.place fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object) {
                    weakSelf.currentUser.place = object;
                    completition(YES, nil);
                } else {
                    completition(NO, error);
                }
            }];
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
withCompletition:(klAccountCompletitionHandler)completition
{
    __weak typeof(self) weakSelf = self;
    if (follow) {
        PFObject *followAction = [PFObject objectWithClassName:klFollowActionKey];
        followAction[klFollowActionFromKey] = self.currentUser.userObject;
        followAction[klFollowActionToKey] = user.userObject;
        [followAction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [weakSelf updateUserData:completition];
            } else {
                completition(NO, error);
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:klFollowActionKey];
        [query whereKey:klFollowActionFromKey
                equalTo:self.currentUser.userObject];
        [query whereKey:klFollowActionToKey
                equalTo:user.userObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *followAction = objects.firstObject;
            [followAction deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [weakSelf updateUserData:completition];
                } else {
                    completition(NO, error);
                }
            }];
        }];
    }
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
