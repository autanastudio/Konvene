//
//  KLConfirmationCodeViewController.m
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLConfirmationCodeViewController.h"
#import "KLLoginManager.h"
#import "KLLoginDetailsViewController.h"
#import "KLLocationSelectTableViewController.h"

@interface KLConfirmationCodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *digitFields;
@property (weak, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (nonatomic, assign) BOOL isMessageShown;

@end

@implementation KLConfirmationCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isMessageShown = NO;
    
    for (UITextField *field in self.digitFields) {
        field.tintColor = [UIColor whiteColor];
        field.text = @"\u200B";
    }
    
    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"CONFIRMATION CODE") withColor:[UIColor whiteColor] spacing:@0.4];
    self.backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                           target:self
                                         selector:@selector(dissmissViewController)];
    self.backButton.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    if (![self isFieldsFistResponder]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponderFieldWithIndex:0];
        });
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.blackNavBar) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)disableControls
{
    [super disableControls];
    self.resendCodeButton.enabled = NO;
    for (UITextField *field in self.digitFields) {
        field.enabled = NO;
    }
}

- (void)enableControls
{
    [super enableControls];
    self.resendCodeButton.enabled = YES;
    for (UITextField *field in self.digitFields) {
        field.enabled = YES;
    }
    if (![self isFieldsFistResponder]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponderFirstEmptyField];
        });
    }
}

#pragma mark - Actions

- (IBAction)resendCode:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self disableControls];
    KLLoginManager *manager = [KLLoginManager sharedManager];
    [manager requestAuthorizationWithHandler:^(BOOL success, NSError *error) {
        [weakSelf enableControls];
    }];
}

- (IBAction)onTerms:(id)sender
{
    
}

- (IBAction)onSubmit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self disableControls];
    KLLoginManager *manager = [KLLoginManager sharedManager];
    manager.verificationCode = [self getCodeString];
    [manager authorizeUserWithHandler:^(KLUserWrapper *user, NSError *error) {
        if (error) {
            self.isMessageShown = YES;
            [weakSelf showNavbarwithErrorMessage:SFLocalized(@"Wrong code!")];
            [weakSelf setTextColorForFields:[UIColor colorFromHex:0xff5484]];
            [self enableControls];
        } else {
            if ([user.isRegistered boolValue]) {
                UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [rootViewController dismissViewControllerAnimated:YES
                                                       completion:^{
                                                       }];
            } else {
                KLLoginDetailsViewController *detailsViewController = [[KLLoginDetailsViewController alloc] init];
                [self.navigationController pushViewController:detailsViewController
                                                     animated:YES];
            }
        }
    }];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *typedString = [textField.text stringByReplacingCharactersInRange:range
                                                                    withString:string];
    if (typedString.length == 0) {
        [self becomeFirstResponderFieldWithIndex:textField.tag-1];
        textField.text = @"\u200B";
    } else {
        UITextField *nextField = [self getTextFieldWithIndex:textField.tag+1];
        [nextField becomeFirstResponder];
        if ([textField.text isEqualToString:@"\u200B"]) {
            textField.text = [string substringFromIndex:[string length] - 1];
        } else {
            nextField.text = [string substringFromIndex:[string length] - 1];
        }
    }
    if ([self getCodeString].length == 6) {
        self.submitButton.enabled = YES;
        [self onSubmit:nil];
        
    } else {
        self.submitButton.enabled = NO;
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.isMessageShown) {
        [self setTextColorForFields:[UIColor whiteColor]];
        self.isMessageShown = NO;
    }
}

- (NSString *)getCodeString
{
    NSString *result = @"";
    for (NSInteger i=0; i<6; i++) {
        NSString *textFieldString = [self getTextFieldWithIndex:i].text;
        if (![textFieldString isEqualToString:@"\u200B"]) {
            result = [result stringByAppendingString:textFieldString];
        }
    }
    return result;
}

- (UITextField *)getTextFieldWithIndex:(NSInteger)index
{
    for (UITextField *textField in self.digitFields) {
        if (textField.tag == index) {
            return textField;
        }
    }
    return nil;
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
    UITextField *textField = [self getTextFieldWithIndex:index];
    [textField becomeFirstResponder];
}

- (void)becomeFirstResponderFirstEmptyField
{
    for (NSInteger i = 0; i<6; i++) {
        UITextField *textField = [self getTextFieldWithIndex:i];
        if ([textField.text isEqualToString:@"\u200B"] || i==5) {
            [textField becomeFirstResponder];
            return;
        }
    }
}

- (void)setTextColorForFields:(UIColor *)color
{
    for (UITextField *textField in self.digitFields) {
        textField.textColor = color;
    }
}

@end
