//
//  KLLoginFormViewController.m
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginFormViewController.h"

@interface KLLoginFormViewController ()
@end

static CGFloat klKeyabordFrameHeight = 0;

@implementation KLLoginFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIKeyboardWillShowNotification
                         withBlock:^(NSNotification *notification) {
        NSValue *rectV = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = rectV.CGRectValue;
        klKeyabordFrameHeight = keyboardFrame.size.height;
        NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        [weakSelf animateFormApearenceWithKeyaboardHeight:keyboardFrame.size.height
                                                 duration:duration.doubleValue];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (klKeyabordFrameHeight != 0) {
        [self animateFormApearenceWithKeyaboardHeight:klKeyabordFrameHeight
                                             duration:.6];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height duration:(NSTimeInterval)duration
{
    self.bottomSubmitButtonPin.constant = height;
    [self.view layoutIfNeeded];
}

- (IBAction)onSubmit:(id)sender
{
}

@end
