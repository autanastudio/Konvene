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
    _number = 0;
    _textPrice.tintColor = [UIColor whiteColor];
    _labelMin.textColor = [UIColor colorFromHex:0x15badd];
    _viewSeparator.backgroundColor = [UIColor colorFromHex:0x15badd];
    
    _viewBottom.backgroundColor = [UIColor colorFromHex:0x0388a6];
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
    return [NSNumber numberWithFloat:_number];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)onTextChanged
{
    CGSize sz = [NSString text:@(_number).description sizeWithFont:_textPrice.font toSize:CGSizeMake(320, 50) lineBreak:(NSLineBreakByWordWrapping)];
    sz.width += 10;
    
    [UIView animateWithDuration:0.1 animations:^{
        _constraintTextW.constant = sz.width;
        [self layoutIfNeeded];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(onTextChanged) withObject:nil afterDelay:0];
    _number = [textField.text stringByReplacingCharactersInRange:range withString:string].intValue;
    return YES;
}

- (void)startAppearAnimation
{
    _labelDollar.alpha = 0;
    _textPrice.alpha = 0;
    _viewSeparator.alpha = 0;
    _labelMin.alpha = 0;
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(0, 30);
    _labelDollar.transform = t;
    _textPrice.transform = t;
    
    t = CGAffineTransformMakeTranslation(0, 15);
    _viewSeparator.transform = t;
    _viewBottom.transform = t;
    _labelMin.transform = t;
    
    [UIView animateWithDuration:0.25
                          delay:0.20
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         
                         _viewSeparator.alpha = 1;
                         _labelMin.alpha = 1;
                         
                         CGAffineTransform t = CGAffineTransformIdentity;
                         _viewSeparator.transform = t;
                         _viewBottom.transform = t;
                         _labelMin.transform = t;
                         
                     } completion:NULL];
    
    [UIView animateWithDuration:0.20
                          delay:0.28
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         
                         _labelDollar.alpha = 1;
                         _textPrice.alpha = 1;
                         
                     } completion:NULL];
    
    [UIView animateWithDuration:0.6
                          delay:0.28
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         
                         CGAffineTransform t = CGAffineTransformIdentity;
                         _labelDollar.transform = t;
                         _textPrice.transform = t;
                         
                     } completion:NULL];
}

- (void)startDisappearAnimation
{
    [UIView animateWithDuration:0.20
                     animations:^{
                         _viewSeparator.alpha = 0;
                         _labelMin.alpha = 0;
                     }
                     completion:NULL];
    [UIView animateWithDuration:0.25
                     animations:^{
                         _labelDollar.alpha = 0;
                         _textPrice.alpha = 0;
                     }
                     completion:NULL];
}

- (void)resetAnimation
{
    
    _viewSeparator.alpha = 1;
    _labelMin.alpha = 1;
    _labelDollar.alpha = 1;
    _textPrice.alpha = 1;
    
    CGAffineTransform t = CGAffineTransformIdentity;
    _viewSeparator.transform = t;
    _labelMin.transform = t;
    _viewBottom.transform = t;
    _labelDollar.transform = t;
    _textPrice.transform = t;
}

@end
