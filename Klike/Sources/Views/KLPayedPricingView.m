//
//  KLPayedPricingView.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPayedPricingView.h"

@interface KLPayedPricingView () <UITextFieldDelegate>

@end

@implementation KLPayedPricingView

@synthesize price = _price;

- (KLEventPrice *)price
{
    NSInteger priceValue = [self.priceInput.text integerValue];
    NSInteger tickets = [self.ticketInput.text integerValue];
    if (priceValue > 0) {
        _price.pricingType = @(KLEventPricingTypePayed);
        _price.pricePerPerson = @(priceValue);
        _price.maximumTickets = @(tickets);
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
    self.priceInput.text = [NSString stringWithFormat:@"%ld", (long)[_price.pricePerPerson integerValue]];
    [self priceValueChanged:self.priceInput];
    self.ticketInput.text = [NSString stringWithFormat:@"%ld", (long)[_price.maximumTickets integerValue]];
}

- (IBAction)priceValueChanged:(id)sender
{
    UITextField *priceInput = (UITextField *)sender;
    
    NSInteger priceValue = [priceInput.text integerValue];
    
    CGFloat persentage = MAX(0,(CGFloat)priceValue*_processing);
    CGFloat youGet = MAX(0, priceValue - persentage);
    
    self.processingLabel.text = [NSString stringWithFormat:@"$%.2f", persentage];
    self.youGetLabel.text = [NSString stringWithFormat:@"$%.2f", youGet];
    
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    
    NSString *typedString = [textField.text stringByReplacingCharactersInRange:range
                                                                    withString:string];
    CGFloat priceValue = [typedString floatValue];
    
    CGFloat persentage = MAX(0,(CGFloat)priceValue*_processing);
    CGFloat youGet = MAX(0, priceValue - persentage);
    
    self.processingLabel.text = [NSString stringWithFormat:@"$%.2f", persentage];
    self.youGetLabel.text = [NSString stringWithFormat:@"$%.2f", youGet];
    return YES;
}

@end
