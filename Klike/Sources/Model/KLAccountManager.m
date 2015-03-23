//
//  KLAccountManager.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAccountManager.h"

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

- (void)uploadUserDataToServer:(klAccountCompletitionhandler)completition
{
    [self.currentUser.userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completition(succeeded, error);
    }];
}

- (void)updateUserData:(klAccountCompletitionhandler)completition
{
    __weak typeof(self) weakSelf = self;
    [self.currentUser.userObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            weakSelf.currentUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
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
}

@end
