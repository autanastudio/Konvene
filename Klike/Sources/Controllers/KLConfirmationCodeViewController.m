//
//  KLConfirmationCodeViewController.m
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLConfirmationCodeViewController.h"

@interface KLConfirmationCodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *digitFields;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation KLConfirmationCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kl_setNavigationBarColor:nil];
    
    for (UITextField *field in self.digitFields) {
        field.tintColor = [UIColor whiteColor];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = SFLocalized(@"CONFIRMATION CODE");
    [self kl_setNavigationBarTitleColor:[UIColor whiteColor]];
    if (![self isFieldsFistResponder]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponderFieldWithIndex:0];
        });
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)resendCode:(id)sender
{
    
}

- (IBAction)onTerms:(id)sender
{
    
}

- (IBAction)onSubmit:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    
    if ([string isEqualToString: @"\n"]) return NO;
    
    NSString *typedString = [textField.text stringByReplacingCharactersInRange: range
                                                                    withString: string];
    if (typedString.length>=1) {
        [self becomeFirstResponderFieldWithIndex:textField.tag+1];
        textField.text = typedString;
    }
    return NO;
}

- (BOOL)isFieldsFistResponder
{
    for (UITextField *textField in self.digitFields) {
        if (textField.isFirstResponder) {
            return YES;
        }
    }
    return NO;
}

- (void)becomeFirstResponderFieldWithIndex:(NSInteger)index
{
    for (UITextField *textField in self.digitFields) {
        if (textField.tag == index) {
            [textField becomeFirstResponder];
            return;
        }
    }
}

@end
