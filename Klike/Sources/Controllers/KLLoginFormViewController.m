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

@property (nonatomic, assign) CGFloat keyboardFrameHeight;
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
        self.keyboardFrameHeight = keyboardFrame.size.height;
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
}

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height
                                       duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.bottomSubmitButtonPin.constant = height;
        self.submitButton.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onSubmit:(id)sender
{
}

@end
