//
//  KLFollowersController.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFollowersController.h"

@interface KLFollowersController ()

@property (nonatomic, assign) KLFollowUserListType type;

@end

@implementation KLFollowersController

- (instancetype)initWithType:(KLFollowUserListType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.type) {
        case KLFollowUserListTypeFollowers:
            [self kl_setTitle:SFLocalized(@"userlist.followers.title") withColor:[UIColor blackColor]];
            break;
            
        case KLFollowUserListTypeFollowing:
            [self kl_setTitle:SFLocalized(@"userlist.following.title") withColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
}

@end
