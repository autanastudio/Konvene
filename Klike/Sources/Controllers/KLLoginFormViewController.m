//
//  KLLoginFormViewController.m
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginFormViewController.h"

@interface KLLoginFormViewController ()
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@end

@implementation KLLoginFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIKeyboardWillShowNotification
                         withBlock:^(NSNotification *notification) {
        NSValue *rectV = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = rectV.CGRectValue;
        weakSelf.keyboardFrameHeight = keyboardFrame.size.height;
        NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        [weakSelf animateFormApearenceWithKeyaboardHeight:keyboardFrame.size.height
                                                 duration:duration.doubleValue];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"";
    [self kl_setNavigationBarColor:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.keyboardFrameHeight != 0) {
        [self animateFormApearenceWithKeyaboardHeight:self.keyboardFrameHeight
                                             duration:.6];
    }
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIKeyboardWillHideNotification
                         withBlock:^(NSNotification *notification) {
                             weakSelf.keyboardFrameHeight = 0;
                             NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
                             [weakSelf animateFormApearenceWithKeyaboardHeight:0
                                                                      duration:duration.doubleValue];
                         }];
}

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height
                                       duration:(NSTimeInterval)duration
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bottomSubmitButtonPin.constant = height;
        weakSelf.submitButton.alpha = 1;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (IBAction)onSubmit:(id)sender
{
}

- (void)dissmissViewController
{
    if (self.kl_parentViewController) {
        [self.view endEditing:YES];
        [self.kl_parentViewController viewController:self
                                    dissmissAnimated:YES];
    } else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
