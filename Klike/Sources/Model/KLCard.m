//
//  KLCard.m
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCard.h"

static NSString *klCardClassName = @"Card";

@implementation KLCard

@dynamic cardId;
@dynamic last4;
@dynamic brand;
@dynamic expMonth;
@dynamic expYear;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klCardClassName;
}

@end
