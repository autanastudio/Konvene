//
//  KLSignUpViewController.m
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSignUpViewController.h"
#import "SFTextField.h"
#import "KLConfirmationCodeViewController.h"
#import "KLCountryCodeViewCntroller.h"
#import "KLLoginManager.h"
#import "NBPhoneNumberUtil.h"

@interface KLSignUpViewController () <UITextFieldDelegate, KLCountryCodeProtocol>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet SFTextField *numberField;
@end

@implementation KLSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kl_setNavigationBarColor:nil];
    
    self.numberField.placeholderColor = [UIColor colorFromHex:0x888AF0];
    self.numberField.placeholder = @"Mobile number";
    self.numberField.tintColor = [UIColor whiteColor];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.countryCodeButton setTitle:[KLLoginManager sharedManager].countryCode
                            forState:UIControlStateNormal];
    
    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"SIGN UP") withColor:[UIColor whiteColor]];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_ar_back"]
                         target:self
                       selector:@selector(dissmissViewController)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.numberField isFirstResponder]) {
        [self.numberField becomeFirstResponder];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)onCountryCode:(id)sender
{
    KLCountryCodeViewCntroller *codeVC = [[KLCountryCodeViewCntroller alloc] init];
    codeVC.delegate = self;
    [self.navigationController pushViewController:codeVC
                                         animated:YES];
}

- (IBAction)onTerms:(id)sender
{
    
}

- (IBAction)onSubmit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    KLLoginManager *manager = [KLLoginManager sharedManager];
    [manager requestAuthorizationWithHandler:^(BOOL success, NSError *error) {
        if (success) {
            KLConfirmationCodeViewController *signUpVC = [[KLConfirmationCodeViewController alloc] init];
            [weakSelf.navigationController pushViewController:signUpVC
                                                     animated:YES];
        }
        
    }];
}

#pragma mark - UITextFieldDelegate method

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:string];
    NSError *error;
    
    NSString *codeString = [KLLoginManager sharedManager].countryCode;
    NSString *phoneString = [codeString stringByAppendingString:newText];
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    
    NBPhoneNumber *phoneNumber = [phoneUtil parse:phoneString
                                    defaultRegion:@"US"
                                            error:&error];
    
    NSString *formattedNumber = [phoneUtil format:phoneNumber
                                     numberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                            error:&error];
    if (error) {
        textField.text = newText;
    } else {
        textField.text = [formattedNumber stringByReplacingOccurrencesOfString:codeString
                                                                    withString:@""];
    }
    BOOL isValid = [phoneUtil isValidNumber:phoneNumber];
    self.submitButton.enabled = isValid;
    if (isValid) {
        formattedNumber = [phoneUtil format:phoneNumber
                               numberFormat:NBEPhoneNumberFormatE164
                                      error:&error];
        [KLLoginManager sharedManager].phoneNumber = formattedNumber;
    }
    
    return NO;
}

#pragma mark - KLCountryCodeProtocol methods

- (void)dissmissCoutryCodeViewControllerWithnewCode:(NSString *)code
{
    if (code) {
        [KLLoginManager sharedManager].countryCode = code;
        [self.countryCodeButton setTitle:code
                                forState:UIControlStateNormal];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
