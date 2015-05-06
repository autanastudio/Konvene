//
//  KLFollowersController.h
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserList.h"

typedef enum : NSUInteger {
    KLFollowUserListTypeFollowers,
    KLFollowUserListTypeFollowing,
} KLFollowUserListType;

@interface KLFollowersController : KLUserList

- (instancetype)initWithType:(KLFollowUserListType)type
                        user:(KLUserWrapper *)user;

@end
