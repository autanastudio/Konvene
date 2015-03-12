//
//  KLConfirmationCodeViewController.m
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLConfirmationCodeViewController.h"
#import "KLLoginManager.h"
#import "KLFormMessageView.h"
#import "KLLoginDetailsViewController.h"

@interface KLConfirmationCodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *digitFields;
@property (nonatomic, assign) BOOL isMessageShown;

@end

@implementation KLConfirmationCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isMessageShown = NO;
    
    [self kl_setNavigationBarColor:nil];
    
    for (UITextField *field in self.digitFields) {
        field.tintColor = [UIColor whiteColor];
        field.text = @"\u200B";
    }
    
    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"CONFIRMATION CODE")];
    [self kl_setNavigationBarTitleColor:[UIColor whiteColor]];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_ar_back"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
//    __weak typeof(self) weakSelf = self;
    KLLoginManager *manager = [KLLoginManager sharedManager];
    [manager requestAuthorizationWithHandler:^(BOOL success, NSError *error) {
    }];
}

- (IBAction)onTerms:(id)sender
{
    
}

- (IBAction)onSubmit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    KLLoginManager *manager = [KLLoginManager sharedManager];
    manager.verificationCode = [self getCodeString];
    [manager authorizeUserWithHandler:^(PFUser *user, NSError *error) {
        if (error) {
            self.isMessageShown = YES;
            [weakSelf showNavbarwithErrorMessage:SFLocalized(@"Wrong code!")];
            [weakSelf setTextColorForFields:[UIColor colorFromHex:0xff5484]];
        } else {
            KLLoginDetailsViewController *detailsViewController = [[KLLoginDetailsViewController alloc] init];
            [self.navigationController pushViewController:detailsViewController
                                                 animated:YES];
        }
    }];
}

- (void)showNavbarwithErrorMessage:(NSString *)errorMessage
{
    if (errorMessage && self.navigationController) {
        KLFormMessageView *messageView = [[KLFormMessageView alloc] initWithMessage:errorMessage];
        [self.navigationController.view addSubview:messageView];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
        CGSize size = [messageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLayoutConstraint *topPin = [messageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-size.height];
        [messageView layoutIfNeeded];
        
        [UIView animateWithDuration:.2 animations:^{
            topPin.constant = 0;
            [messageView.superview layoutIfNeeded];
        }];
        [UIView animateWithDuration:.2
                              delay:5
                            options:0
                         animations:^{
                             topPin.constant = -size.height;
                             [messageView.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [messageView removeFromSuperview];
                         }];
    }
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
    } else if(typedString.length == 1) {
        [self becomeFirstResponderFieldWithIndex:textField.tag+1];
        textField.text = typedString;
    } else {
        textField.text = [string substringFromIndex:[string length] - 1];
        [self becomeFirstResponderFieldWithIndex:textField.tag+1];
    }
    self.submitButton.enabled = [self getCodeString].length == 6;
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
        result = [result stringByAppendingString:[self getTextFieldWithIndex:i].text];
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
    for (UITextField *textField in self.digitFields) {
        if (textField.tag == index) {
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
