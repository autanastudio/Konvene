//
//  KLPricingView.m
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPricingView.h"

@implementation KLPricingView

- (instancetype)initWithEventPrice:(KLEventPrice *)eventPrice
{
    self= [super init];
    if (self) {
        [self initializeWithPrice:eventPrice];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeWithPrice:nil];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEventPrice:nil];
}

- (void)initializeWithPrice:(KLEventPrice *)price
{
    if (!price) {
        price = [KLEventPrice object];
        price.pricingType = @(KLEventPricingTypeFree);
        self.price = price;
    } else {
        [self configureWithPrice:price];
    }
}

- (void)configureWithPrice:(KLEventPrice *)price
{
    self.price = price;
}

@end
