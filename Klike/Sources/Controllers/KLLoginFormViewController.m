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
static CGFloat klSubmitButtonHeight = 56;

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

- (void)addSubmitButtonWithTitle:(NSString *)title
{
    self.submitButton = [[UIButton alloc] init];
    self.submitButton.titleLabel.text = title;
    [self.view addSubview:self.submitButton];
    [self.submitButton autoSetDimension:ALDimensionHeight
                                 toSize:klSubmitButtonHeight];
    self.submitButton.backgroundColor = [UIColor colorFromHex:0x6466CA];
    [self.submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.submitButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.bottomSubmitButtonPin = [self.submitButton autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                                                     withInset:0.];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (klKeyabordFrameHeight != 0) {
        [self animateFormApearenceWithKeyaboardHeight:klKeyabordFrameHeight
                                             duration:.6];
    }
}

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:.2
         usingSpringWithDamping:.6
          initialSpringVelocity:1
                        options:0
                     animations:^{
                         self.bottomSubmitButtonPin.constant = -height;
                         self.submitButton.alpha = 1;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (IBAction)onSubmit:(id)sender
{
}

@end
