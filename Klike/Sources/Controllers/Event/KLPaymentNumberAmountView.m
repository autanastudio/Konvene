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
    return [[[NSBundle mainBundle] loadNibNamed:@"KLPaymentNumberAmountView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    _number = 0;
    
    _viewSeparator.backgroundColor = [UIColor colorFromHex:0x588fe1];
    _lavelTickets.textColor = [UIColor colorFromHex:0x588fe1];
}

- (void)setNumber:(int)number
{
    _number = number;
    _textPrice.tintColor = [UIColor whiteColor];
    _textPrice.text = @(_number).description;
//    _labelNumber.text = @(_number).description;
}

- (IBAction)onPlus:(id)sender
{
    self.number = self.number + 1;
}

- (IBAction)onMinus:(id)sender
{
    if (self.number > 1)
        self.number = self.number - 1;
}

- (BOOL)resignFirstResponder
{
    [_textPrice resignFirstResponder];
    return [super resignFirstResponder];
}

@end
