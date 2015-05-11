//
//  KLEventExtension.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventExtension.h"

static NSString *klEventExtensionClassName = @"EventExtension";

@implementation KLEventExtension

@dynamic photos;
@dynamic comments;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klEventExtensionClassName;
}

@end
