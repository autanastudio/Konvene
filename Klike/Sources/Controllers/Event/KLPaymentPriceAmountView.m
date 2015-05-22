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

- (BOOL)resignFirstResponder
{
    [_textPrice resignFirstResponder];
    return [super resignFirstResponder];
}

- (NSNumber*)number
{
    return [NSNumber numberWithFloat:_textPrice.text.floatValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)onTextChanged
{
    CGSize sz = [NSString text:_textPrice.text sizeWithFont:_textPrice.font toSize:CGSizeMake(320, 50) lineBreak:(NSLineBreakByClipping)];
    sz.width += 30;
    
    [UIView animateWithDuration:0.1 animations:^{
        _constraintTextW.constant = sz.width;
        [self layoutIfNeeded];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(onTextChanged) withObject:nil afterDelay:0];
    return YES;
}

@end
