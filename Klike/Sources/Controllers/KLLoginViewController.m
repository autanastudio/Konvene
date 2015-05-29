//
//  KLLoginViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginViewController.h"
#import "KLTutorialPageViewController.h"
#import "KLCountryCodeViewCntroller.h"
#import "KLLoginManager.h"
#import "KLLoginDetailsViewController.h"
#import "SFTextField.h"
#import "KLConfirmationCodeViewController.h"
#import "NBPhoneNumberUtil.h"

typedef enum : NSUInteger {
    KLLoginVCStateTutorial,
    KLLoginVCStateJoin,
    KLLoginVCStateChanging
} KLLoginVCState;

static NSInteger klTutorialPagesCount = 4;

@interface KLLoginViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITextFieldDelegate, KLCountryCodeProtocol, KLChildrenViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *tutorialPageViewController;
@property (weak, nonatomic) IBOutlet UIView *tutorialViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet SFTextField *numberField;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) NSArray *tutorialTitles;
@property (nonatomic, strong) NSArray *tutorialTexts;
@property (nonatomic, strong) NSArray *tutorialAnimations;
@property (nonatomic, strong) NSArray *tutorialAnimationsCount;
@property (nonatomic, strong) NSArray *tutorialAnimationInset;
@property (nonatomic, strong) NSArray *tutorialFrameSize;

@property (nonatomic, assign) KLLoginVCState state;

//Animation
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinPanelTutorialConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinPanelBgTutorialConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavBarContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarBgConstraint;
@property (strong, nonatomic) NSLayoutConstraint *joinPanelConstraint;
@property (strong, nonatomic) NSLayoutConstraint *joinPanelBgConstraint;

@property (weak, nonatomic) IBOutlet UIView *joinPanelView;
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;
@property (weak, nonatomic) IBOutlet UIView *joinPanelBgView;

@end

static CGFloat klFakeNavBarHeight = 64.;

@implementation KLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.state = KLLoginVCStateTutorial;
    
    self.tutorialTitles = @[SFLocalized(@"kl_tutorial_title_1"),
                            SFLocalized(@"kl_tutorial_title_2"),
                            SFLocalized(@"kl_tutorial_title_3"),
                            SFLocalized(@"kl_tutorial_title_4")];
    self.tutorialTexts = @[SFLocalized(@"kl_tutorial_text_1"),
                           SFLocalized(@"kl_tutorial_text_2"),
                           SFLocalized(@"kl_tutorial_text_3"),
                           SFLocalized(@"kl_tutorial_text_4")];
    
    self.tutorialAnimations = @[@"", @"create_anim_real_%05d", @"throw_in_%05d", @"rating_%05d"];
    self.tutorialAnimationInset = @[@0, @(-1), @0, @46];
    self.tutorialAnimationsCount = @[@0, @106, @136, @117];
    
    self.tutorialPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
    self.tutorialPageViewController.dataSource = self;
    self.tutorialPageViewController.delegate = self;
    self.tutorialPageViewController.view.frame = self.tutorialViewContainer.bounds;
    [self.tutorialPageViewController setViewControllers:@[[self viewControllerAtIndex:0]]
                                              direction:UIPageViewControllerNavigationDirectionForward
                                               animated:NO
                                             completion:nil];
    [self addChildViewController:self.tutorialPageViewController];
    [self.tutorialViewContainer addSubview:[self.tutorialPageViewController view]];
    [self.tutorialPageViewController didMoveToParentViewController:self];
    
    self.numberField.placeholderColor = [UIColor colorFromHex:0x888AF0];
    self.numberField.font = self.numberField.font;
    self.numberField.placeholder = @"Mobile Number";
    self.numberField.tintColor = [UIColor whiteColor];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.joinPanelConstraint = [self.joinPanelView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                              withInset:klFakeNavBarHeight-4.];
    self.joinPanelConstraint.active = NO;
    self.joinPanelBgConstraint = [self.joinPanelBgView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                        withInset:klFakeNavBarHeight];
    self.joinPanelBgConstraint.active = NO;
    
    self.backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                           target:self
                                         selector:@selector(onFakeBackButton:)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;
    
    UISwipeGestureRecognizer *popGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onFakeBackSwipe)];
    popGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"";
    [self kl_setNavigationBarColor:nil];
    [self.countryCodeButton setTitle:[KLLoginManager sharedManager].countryCode
                            forState:UIControlStateNormal];
    if (self.state == KLLoginVCStateJoin && !self.numberField.isFirstResponder) {
        [self.numberField becomeFirstResponder];
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

- (void)showJoin
{
    if (self.state == KLLoginVCStateChanging) {
        return;
    }
    [self checkNumber];
    self.state = KLLoginVCStateChanging;
    [self.numberField becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.navBarBgConstraint.constant = klFakeNavBarHeight;
        weakSelf.joinPanelBgTutorialConstraint.active = NO;
        weakSelf.joinPanelBgConstraint.active = YES;
        [weakSelf.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.NavBarContraint.constant = klFakeNavBarHeight;
        weakSelf.joinPanelTutorialConstraint.active = NO;
        weakSelf.joinPanelConstraint.active = YES;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.state = KLLoginVCStateJoin;
            self.navigationItem.leftBarButtonItem = self.backButton;
        }
    }];
}

- (void)hideJoin
{
    if (self.state == KLLoginVCStateChanging) {
        return;
    }
    self.state = KLLoginVCStateChanging;
    self.navigationItem.leftBarButtonItem = nil;
    [self.numberField resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.23 animations:^{
        weakSelf.navBarBgConstraint.constant = 0;
        weakSelf.joinPanelBgConstraint.active = NO;
        weakSelf.joinPanelBgTutorialConstraint.active = YES;
        [weakSelf.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.NavBarContraint.constant = 0;
        weakSelf.joinPanelConstraint.active = NO;
        weakSelf.joinPanelTutorialConstraint.active = YES;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.state = KLLoginVCStateTutorial;
            weakSelf.submitButton.enabled = YES;
        }
    }];
}

- (void)disableControls
{
    [super disableControls];
    self.numberField.enabled = NO;
    self.countryCodeButton.enabled = NO;
}

- (void)enableControls
{
    [super enableControls];
    self.numberField.enabled = YES;
    self.countryCodeButton.enabled = YES;
}

#pragma mark - Actions

- (void)onFakeBackSwipe
{
    if (self.state == KLLoginVCStateJoin) {
        [self hideJoin];
    }
}

- (IBAction)onTerms:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://konveneapp.com/terms.html"]];
}

- (IBAction)onJoin:(id)sender
{
    if (self.state == KLLoginVCStateTutorial) {
        [self.numberField becomeFirstResponder];
    } else if (self.state == KLLoginVCStateJoin){
        [self disableControls];
        __weak typeof(self) weakSelf = self;
        KLLoginManager *manager = [KLLoginManager sharedManager];
        [manager requestAuthorizationWithHandler:^(BOOL success, NSError *error) {
            if (success) {
                [self enableControls];
                KLConfirmationCodeViewController *signUpVC = [[KLConfirmationCodeViewController alloc] init];
                [weakSelf.navigationController pushViewController:signUpVC
                                                         animated:YES];
            } else {
                [weakSelf showNavbarwithErrorMessage:SFLocalized(@"Server error! Try again!")];
            }
            [weakSelf enableControls];
        }];
    }
}

- (IBAction)onPhoneCountryCode:(id)sender
{
    KLCountryCodeViewCntroller *codeVC = [[KLCountryCodeViewCntroller alloc] init];
    codeVC.delegate = self;
    codeVC.kl_parentViewController = self;
    [self.navigationController pushViewController:codeVC
                                         animated:YES];
}

- (IBAction)onFakeBackButton:(id)sender
{
    [self hideJoin];
}

#pragma mark - UIPageViewControllerDataSource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [(KLTutorialPageViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [(KLTutorialPageViewController *)viewController index];
    if (index == klTutorialPagesCount-1) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (KLTutorialPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index==0) {
        KLTutorialPageViewController *childViewController = [KLTutorialPageViewController
                                                             tutorialPageControllerWithTitle:self.tutorialTitles[index]
                                                             text:self.tutorialTexts[index]
                                                             animationImages:nil
                                                             animationDuration:0
                                                             topInsetForanimation:0];
        childViewController.index = index;
        return childViewController;
    } else {
        NSArray *images = [UIImageView imagesForAnimationWithnamePattern:self.tutorialAnimations[index]
                                                                   count:self.tutorialAnimationsCount[index]];
        KLTutorialPageViewController *childViewController = [KLTutorialPageViewController
                                                             tutorialPageControllerWithTitle:self.tutorialTitles[index]
                                                             text:self.tutorialTexts[index]
                                                             animationImages:images
                                                             animationDuration:(NSTimeInterval)images.count/(NSTimeInterval)25
                                                             topInsetForanimation:[self.tutorialAnimationInset[index] floatValue]];
        childViewController.index = index;
        return childViewController;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return klTutorialPagesCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - KLCountryCodeProtocol methods

- (void)dissmissCoutryCodeViewControllerWithnewCode:(NSString *)code
{
    if (code) {
        [KLLoginManager sharedManager].countryCode = code;
        [self.countryCodeButton setTitle:code
                                forState:UIControlStateNormal];
        if (self.state == KLLoginVCStateJoin) {
            [self checkNumber];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KLChildrenViewControllerDelegate

- (void)viewController:(UIViewController *)viewController
      dissmissAnimated:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.state == KLLoginVCStateTutorial) {
        [self showJoin];
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:string];
    NSError *error;
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NBPhoneNumber *phoneNumber = [self getCurrentPhoneNumberWithFieldValue:newText];
    NSString *formattedNumber = [phoneUtil format:phoneNumber
                                     numberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                            error:&error];
    if (error || !phoneNumber) {
        textField.text = newText;
    } else {
        textField.text = [formattedNumber stringByReplacingOccurrencesOfString:[KLLoginManager sharedManager].countryCode
                                                                    withString:@""];
    }
    [self checkNumber];
    
    return NO;
}

- (NBPhoneNumber *)getCurrentPhoneNumberWithFieldValue:(NSString *)text
{
    NSError *error;
    NSString *codeString = [KLLoginManager sharedManager].countryCode;
    NSString *phoneString = [codeString stringByAppendingString:text];
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    
    NBPhoneNumber *phoneNumber = [phoneUtil parse:phoneString
                                    defaultRegion:@"US"
                                            error:&error];
    if (error) {
        return nil;
    } else {
        return phoneNumber;
    }
}

- (void)checkNumber
{
    NSError *error;
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NBPhoneNumber *phoneNumber = [self getCurrentPhoneNumberWithFieldValue:self.numberField.text];
    BOOL isValid = [phoneUtil isValidNumber:phoneNumber];
    self.submitButton.enabled = isValid;
    if (isValid) {
        NSString *formattedNumber = [phoneUtil format:phoneNumber
                               numberFormat:NBEPhoneNumberFormatE164
                                      error:&error];
        [KLLoginManager sharedManager].phoneNumber = formattedNumber;
    }
}

@end
