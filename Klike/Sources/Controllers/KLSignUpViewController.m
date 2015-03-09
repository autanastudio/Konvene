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

@interface KLSignUpViewController ()
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = SFLocalized(@"SIGN UP");
    [self kl_setNavigationBarTitleColor:[UIColor whiteColor]];
    
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
    
}

- (IBAction)onTerms:(id)sender
{
    
}

- (IBAction)onSubmit:(id)sender
{
    KLConfirmationCodeViewController *signUpVC = [[KLConfirmationCodeViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

@end
