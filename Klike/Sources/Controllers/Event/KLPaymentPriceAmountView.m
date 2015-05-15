//
//  KLPaymentPriceAmountView.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentPriceAmountView.h"

@implementation KLPaymentPriceAmountView

+ (KLPaymentPriceAmountView*)priceAmountView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KLPaymentPriceAmountView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    
    _textPrice.tintColor = [UIColor whiteColor];
    _labelMin.textColor = [UIColor colorFromHex:0x15badd];
    _viewSeparator.backgroundColor = [UIColor colorFromHex:0x15badd];
}

- (void)setMinimum:(NSDecimalNumber *)minimum
{
    _minimum = minimum;
    _labelMin.text = [NSString stringWithFormat:@"min $%@", [minimum descriptionWithLocale:[NSLocale systemLocale]]];
}

@end
