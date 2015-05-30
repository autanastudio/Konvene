//
//  KLThrowPricingView.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLThrowPricingView.h"

@implementation KLThrowPricingView

@synthesize price = _price;

- (KLEventPrice *)price
{
    NSInteger minimalAmount = [self.minimalAmaountInput.text integerValue];
    NSInteger suggestedAmount = [self.suggestedAmount.text integerValue];
    if (minimalAmount > 0 || suggestedAmount > 0) {
        _price.pricingType = @(KLEventPricingTypeThrow);
        _price.minimumAmount = @(minimalAmount);
        _price.suggestedAmount = @(suggestedAmount);
    }
    return _price;
}

- (void)setPrice:(KLEventPrice *)price
{
    _price = price;
}

- (void)configureWithPrice:(KLEventPrice *)price
{
    [super configureWithPrice:price];
    self.minimalAmaountInput.text = [NSString stringWithFormat:@"%ld", (long)[_price.minimumAmount integerValue]];
    self.suggestedAmount.text = [NSString stringWithFormat:@"%ld", (long)[_price.suggestedAmount integerValue]];
}

@end
