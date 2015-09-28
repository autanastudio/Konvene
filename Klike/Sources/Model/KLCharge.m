//
//  KLCharge.m
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCharge.h"

static NSString *klChargeClassName = @"Charge";

@implementation KLCharge

@dynamic chargeId;
@dynamic paymentId;
@dynamic owner;
@dynamic event;
@dynamic card;
@dynamic amount;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klChargeClassName;
}

@end