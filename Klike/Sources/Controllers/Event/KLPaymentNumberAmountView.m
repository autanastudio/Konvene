//
//  KLPaymentNumberAmountView.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentNumberAmountView.h"
#import "NSString+KL_Additions.h"



@implementation KLPaymentNumberAmountView

+ (KLPaymentNumberAmountView*)paymentNumberAmountView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KLPaymentNumberAmountView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    _number = 1;
    
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
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _number = text.intValue;
    return YES;
}

@end
