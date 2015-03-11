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
        self.currentUser = [PFUser currentUser];
    }
    return self;
}

- (BOOL)isCurrentUserAuthorized
{
    return self.currentUser;
}

@end
