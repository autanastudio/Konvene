//
//  KLPayedPricingController.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPayedPricingController.h"

@interface KLPayedPricingController () <UITextFieldDelegate>

@end

@implementation KLPayedPricingController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title
{
    return @"Fixed Price";
}

- (IBAction)priceValueChanged:(id)sender
{
    UITextField *priceInput = (UITextField *)sender;
    
    CGFloat priceValue = [priceInput.text floatValue];
    
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
