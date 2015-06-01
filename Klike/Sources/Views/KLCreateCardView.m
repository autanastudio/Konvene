//
//  KLCreateCardView.m
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCreateCardView.h"
#import "SFTextField.h"
#import <PaymentKit/PTKView.h>
#import <Stripe/Stripe.h>



@interface KLCreateCardView () <UITextFieldDelegate>

@end



@implementation KLCreateCardView

+ (KLCreateCardView*)createCardView
{
    UINib *nib = [UINib nibWithNibName:@"CreateCardView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (BOOL)resignFirstResponder
{
    [_cardNumberField resignFirstResponder];
    [_expireDateField resignFirstResponder];
    [_keyField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)awakeFromNib
{
    self.cardNumberField.placeholder = SFLocalized(@"settings.cardView.cardNumber");
    self.expireDateField.placeholder = SFLocalized(@"settings.cardView.ExpireDate");
    self.keyField.placeholder= SFLocalized(@"settings.cardView.cvs");
    
    self.cardNumberField.font = [UIFont helveticaNeue:SFFontStyleRegular size:14.];
    self.expireDateField.font = [UIFont helveticaNeue:SFFontStyleRegular size:14.];
    self.keyField.font = [UIFont helveticaNeue:SFFontStyleRegular size:14.];
}

- (void)configureColorsForSettings
{
    self.placeholderColor = [UIColor colorFromHex:0x91919f];
    self.linesColor = [UIColor colorFromHex:0xf2f2f7];
    self.textColor = [UIColor blackColor];
    self.buttonTintColor = [UIColor colorFromHex:0x6466ca];
    self.errorColor = [UIColor colorFromHex:0xff1255];
}

- (void)setTextTintColor:(UIColor *)color
{
    self.cardNumberField.tintColor = color;
    self.expireDateField.tintColor = color;
    self.keyField.tintColor = color;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.cardNumberField.placeholderColor = placeholderColor;
    self.expireDateField.placeholderColor = placeholderColor;
    self.keyField.placeholderColor = placeholderColor;
}

- (void)setLinesColor:(UIColor *)linesColor
{
    _linesColor = linesColor;
    for (UIView *line in self.lines) {
        line.backgroundColor = linesColor;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.cardNumberField.textColor = textColor;
    self.expireDateField.textColor = textColor;
    self.keyField.textColor = textColor;
}

- (void)setButtonTintColor:(UIColor *)buttonTintColor
{
    _buttonTintColor = buttonTintColor;
    self.camButton.tintColor = buttonTintColor;
    self.infoButton.tintColor = buttonTintColor;
}

- (IBAction)onShowScan:(id)sender
{
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(showScanCardControllerCardView:)]) {
        [self.deleagate showScanCardControllerCardView:self];
    }
}

- (IBAction)onShowCSVInfo:(id)sender
{
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(showCSVInfoControllerCardView:)]) {
        [self.deleagate showCSVInfoControllerCardView:self];
    }
}

- (void)updateValidateStatus
{
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(cardChangeValidCardControllerCardView:)]) {
        [self.deleagate cardChangeValidCardControllerCardView:self];
    }
}

- (STPCard *)card
{
    STPCard *card = [[STPCard alloc] init];
    card.number = [[self cardNumber] string];
    card.expMonth = [[self cardExpiry] month];
    card.expYear = [[self cardExpiry] year];
    card.cvc = [[self cardCVC] string];
    return card;
}

- (void)setEnabled:(BOOL)enabled
{
    self.cardNumberField.enabled = enabled;
    self.expireDateField.enabled = enabled;
    self.keyField.enabled = enabled;
}

- (BOOL)valid
{
    return self.validateStatus == (KLCardValidStatusCVS |
                                   KLCardValidStatusExpire |
                                   KLCardValidStatusCardNumber);
}

#pragma mark - Accessors

- (PTKCardNumber *)cardNumber
{
    return [PTKCardNumber cardNumberWithString:self.cardNumberField.text];
}

- (PTKCardExpiry *)cardExpiry
{
    return [PTKCardExpiry cardExpiryWithString:self.expireDateField.text];
}

- (PTKCardCVC *)cardCVC
{
    return [PTKCardCVC cardCVCWithString:self.keyField.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([textField isEqual:self.cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range
                                                replacementString:string];
    }
    
    if ([textField isEqual:self.expireDateField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range
                                           replacementString:string];
    }
    
    if ([textField isEqual:self.keyField]) {
        return [self cardCVCShouldChangeCharactersInRange:range
                                        replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.cardNumberField]) {
        [self.expireDateField becomeFirstResponder];
    } else if ([textField isEqual:self.expireDateField]) {
        [self.keyField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range
                                   replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid])
        return NO;
    
    if (replacementString.length > 0) {
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        self.cardNumberField.text = [cardNumber formattedString];
    }
    
    if ([cardNumber isValid]) {
        self.cardNumberField.textColor = self.textColor;
        self.validateStatus |= KLCardValidStatusCardNumber;
        [self updateValidateStatus];
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        self.cardNumberField.textColor = self.errorColor;
        self.validateStatus &= ~KLCardValidStatusCardNumber;
        [self updateValidateStatus];
    } else if (![cardNumber isValidLength]) {
        self.cardNumberField.textColor = self.textColor;
        self.validateStatus &= ~KLCardValidStatusCardNumber;
        [self updateValidateStatus];
    }
    
    UITextPosition *caretPos = [self.cardNumberField  positionFromPosition:[self.cardNumberField beginningOfDocument] offset:range.location + replacementString.length];
    [self.cardNumberField setSelectedTextRange:[self.cardNumberField textRangeFromPosition:caretPos toPosition:caretPos]];
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range
                              replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.expireDateField.text stringByReplacingCharactersInRange:range
                                                                                withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    PTKCardExpiry *cardExpiry = [PTKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        self.expireDateField.text = [cardExpiry formattedStringWithTrail];
    } else {
        self.expireDateField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        self.expireDateField.textColor = self.textColor;
        self.validateStatus |= KLCardValidStatusExpire;
        [self updateValidateStatus];
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        self.expireDateField.textColor = self.errorColor;
        self.validateStatus &= ~ KLCardValidStatusExpire;
        [self updateValidateStatus];
    } else if (![cardExpiry isValidLength]) {
        self.expireDateField.textColor = self.textColor;
        self.validateStatus &= ~ KLCardValidStatusExpire;
        [self updateValidateStatus];
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range
                           replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.keyField.text stringByReplacingCharactersInRange:range
                                                                         withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    PTKCardCVC *cardCVC = [PTKCardCVC cardCVCWithString:resultString];
    PTKCardType cardType = [[PTKCardNumber cardNumberWithString:self.cardNumberField.text] cardType];
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) return NO;
    
    // Strip non-digits
    self.keyField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        self.keyField.textColor = self.textColor;
        self.validateStatus |= KLCardValidStatusCVS;
        [self updateValidateStatus];
    } else {
        self.keyField.textColor = self.errorColor;
        self.validateStatus &= ~KLCardValidStatusCVS;
        [self updateValidateStatus];
    }
    
    return NO;
}

- (void)setCardNumber:(NSString *)cardNumberString
{
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:cardNumberString];
    
    if (![cardNumber isPartiallyValid])
        return;
    
    if (cardNumberString.length > 0) {
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        self.cardNumberField.text = [cardNumber formattedString];
    }
    
    if ([cardNumber isValid]) {
        self.cardNumberField.textColor = self.textColor;
        self.validateStatus = self.validateStatus | KLCardValidStatusCardNumber;
        [self updateValidateStatus];
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        self.cardNumberField.textColor = self.errorColor;
        self.validateStatus = self.validateStatus ^ KLCardValidStatusCardNumber;
        [self updateValidateStatus];
    } else if (![cardNumber isValidLength]) {
        self.cardNumberField.textColor = self.textColor;
    }
}

- (NSString *)textByRemovingUselessSpacesFromString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\u200B"
                                             withString:@""];
}

@end
