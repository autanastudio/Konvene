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

@interface KLSignUpViewController () <KLCountryCodeProtocol>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet SFTextField *numberField;
@end

@implementation KLSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kl_setNavigationBarColor:nil];
    
    self.numberField.placeholderColor = [UIColor colorFromHex:0x8e9bb4];
    self.numberField.placeholder = @"Mobile number";
    self.numberField.tintColor = [UIColor whiteColor];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"SIGN UP")];
    [self kl_setNavigationBarTitleColor:[UIColor whiteColor]];
    
    [self.countryCodeButton setTitle:[KLLoginManager sharedManager].countryCode
                            forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.numberField isFirstResponder]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.numberField becomeFirstResponder];
        });
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
    KLConfirmationCodeViewController *signUpVC = [[KLConfirmationCodeViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

#pragma mark - KLCountryCodeProtocol methods

- (void)dissmissCoutryCodeViewControllerWithnewCode:(NSString *)code
{
    [KLLoginManager sharedManager].countryCode = code;
    [self.countryCodeButton setTitle:code
                            forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
