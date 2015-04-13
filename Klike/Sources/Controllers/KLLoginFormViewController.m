//
//  KLLoginFormViewController.m
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginFormViewController.h"
#import "KLFormMessageView.h"

@interface KLLoginFormViewController ()
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@end

@implementation KLLoginFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isNavigationBarErrorShown = NO;
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
    [self subscribeForNotification:UIKeyboardWillHideNotification
                         withBlock:^(NSNotification *notification) {
                             weakSelf.keyboardFrameHeight = 0;
                             NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
                             [weakSelf animateFormApearenceWithKeyaboardHeight:0
                                                                      duration:duration.doubleValue];
                         }];
    
    self.spinnerImageView.animationImages = [UIImageView imagesForAnimationWithnamePattern:@"spinner_white_%05d"
                                                                                     count:@80];
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

- (void)disableControls
{
    [self.spinnerImageView startAnimating];
    self.submitLoadingView.hidden = NO;
    self.submitButton.enabled = NO;
    self.backButton.enabled = NO;
}

- (void)enableControls
{
    self.submitLoadingView.hidden = YES;
    self.submitButton.enabled = YES;
    self.backButton.enabled = YES;
    [self.spinnerImageView stopAnimating];
}

- (void)showNavbarwithErrorMessage:(NSString *)errorMessage
{
    if (errorMessage && self.navigationController) {
        self.isNavigationBarErrorShown = YES;
        KLFormMessageView *messageView = [[KLFormMessageView alloc] initWithMessage:errorMessage];
        [self.navigationController.view addSubview:messageView];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeLeading
                                      withInset:0];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing
                                      withInset:0];
        CGSize size = [messageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLayoutConstraint *topPin = [messageView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                   withInset:-size.height];
        [messageView layoutIfNeeded];
        [self setNeedsStatusBarAppearanceUpdate];
        
        __weak typeof(self) weakSelf = self;
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
                             weakSelf.isNavigationBarErrorShown = NO;
                             [weakSelf setNeedsStatusBarAppearanceUpdate];
                             [weakSelf setNeedsStatusBarAppearanceUpdate];
                             [messageView removeFromSuperview];
                         }];
    }
}

@end
