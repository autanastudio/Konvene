//
//  KLActivity.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivity.h"

static NSString *klActivityClassName = @"Activity";

@implementation KLActivity

@dynamic activityType;
@dynamic from;
@dynamic event;
@dynamic users;
@dynamic photos;
@dynamic observers;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klActivityClassName;
}

@end
