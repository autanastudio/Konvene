//
//  KLSignUpViewController.m
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSignUpViewController.h"
#import "SFTextField.h"

@interface KLSignUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSubmitButtonPin;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet SFTextField *numberField;
@end

static CGFloat klKeyabordFrameHeight = 0;

@implementation KLSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kl_setNavigationBarColor:nil];
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIKeyboardWillShowNotification withBlock:^(NSNotification *notification) {
        NSValue *rectV = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = rectV.CGRectValue;
        klKeyabordFrameHeight = keyboardFrame.size.height;
        NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        [weakSelf animateFormApearenceWithKeyaboardHeight:keyboardFrame.size.height duration:duration.doubleValue];
    }];
    
    self.numberField.placeholderColor = [UIColor colorFromHex:0x8e9bb4];
    self.numberField.placeholder = @"Mobile number";
    self.numberField.tintColor = [UIColor whiteColor];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:.2
         usingSpringWithDamping:.6
          initialSpringVelocity:1
                        options:0
                     animations:^{
                         self.bottomSubmitButtonPin.constant = height;
                         self.submitButton.alpha = 1;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = SFLocalized(@"SIGN UP");
    
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],
                                               NSForegroundColorAttributeName,
                                               [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                                style:SFFontStyleMedium
                                                                 size:16.],
                                               NSFontAttributeName,
                                               nil];
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    
    if (![self.numberField isFirstResponder]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.numberField becomeFirstResponder];
        });
    }
    if (klKeyabordFrameHeight != 0) {
        [self animateFormApearenceWithKeyaboardHeight:klKeyabordFrameHeight duration:.6];
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


@end
