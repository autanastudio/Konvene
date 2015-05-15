//
//  KLPaymentNumberAmountView.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentNumberAmountView.h"

@implementation KLPaymentNumberAmountView

+ (KLPaymentNumberAmountView*)paymentNumberAmountView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KLPaymentPriceAmountView" owner:nil options:nil] objectAtIndex:0];
}

@end
