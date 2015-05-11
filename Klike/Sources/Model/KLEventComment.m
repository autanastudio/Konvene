//
//  KLEventComment.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventComment.h"

static NSString *klEventCommentClassName = @"EventComment";

@implementation KLEventComment

@dynamic text;
@dynamic owner;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klEventCommentClassName;
}

@end
