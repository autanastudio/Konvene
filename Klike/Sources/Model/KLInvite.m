//
//  KLInvite.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInvite.h"

static NSString *klInviteClassName = @"Invite";

@implementation KLInvite

@dynamic status;
@dynamic event;
@dynamic from;
@dynamic to;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klInviteClassName;
}

@end
