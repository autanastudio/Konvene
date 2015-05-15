//
//  KLUserPayment.m
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserPayment.h"

static NSString *klUserPaymentClassName = @"userPayment";

@implementation KLUserPayment

@dynamic cards;
@dynamic customerId;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klUserPaymentClassName;
}

- (NSArray *)cards
{
    if (!self[sf_key(cards)]) {
        return [NSArray array];
    } else {
        return self[sf_key(cards)];
    }
}

@end
