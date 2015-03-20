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
#import "KLSignUpViewController.h"
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
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@property (weak, nonatomic) IBOutlet SFTextField *numberField;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (nonatomic, strong) UIButton *useCurrentPhoneNumber;
@property (nonatomic, strong) UIBarButtonItem *backButton;

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
@property (nonatomic, strong) NSLayoutConstraint *usePhoneButtonConstraint;

@property (weak, nonatomic) IBOutlet UIView *joinPanelView;
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;
@property (weak, nonatomic) IBOutlet UIView *joinPanelBgView;

@end

static CGFloat klFakeNavBarHeight = 64.;
static CGFloat klShowUseCurrentPhone = 17.;
static CGFloat klHideUseCurrentPhone = 50.;

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
    self.tutorialAnimations = @[@"rating", @"create_anim_real", @"create_anim_real", @"create_anim_real"];
    self.tutorialAnimationInset = @[@48, @0, @0, @0];
    self.tutorialAnimationsCount = @[@117, @106, @106, @106];
    
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
    self.numberField.placeholder = @"Mobile Number";
    self.numberField.tintColor = [UIColor whiteColor];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.useCurrentPhoneNumber = [[UIButton alloc] init];
    NSDictionary * wordToColorMapping = @{ SFLocalized(@"kl_use_current_hpone_number_1") : [UIColor whiteColor],
                                           SFLocalized(@"kl_use_current_hpone_number_2") : [UIColor colorFromHex:0x7577E0],};
    NSDictionary * wordToFontMapping = @{ SFLocalized(@"kl_use_current_hpone_number_1") : [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                                                                           style:SFFontStyleMedium
                                                                                                            size:12],
                                           SFLocalized(@"kl_use_current_hpone_number_2") : [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                                                                            style:SFFontStyleRegular
                                                                                                             size:11],};
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSString *word in wordToColorMapping) {
        UIColor *color = wordToColorMapping[word];
        UIFont *font = wordToFontMapping[word];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font};
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
        [string appendAttributedString:subString];
    }
    [self.useCurrentPhoneNumber setAttributedTitle:string
                                          forState:UIControlStateNormal];
    self.useCurrentPhoneNumber.titleLabel.numberOfLines = 0;
    self.useCurrentPhoneNumber.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.useCurrentPhoneNumber sizeToFit];
    [self.joinPanelView insertSubview:self.useCurrentPhoneNumber
                         belowSubview:self.submitButton];
    self.usePhoneButtonConstraint = [self.useCurrentPhoneNumber autoPinEdge:ALEdgeTop
                                                                     toEdge:ALEdgeTop
                                                                     ofView:self.separatorView
                                                                 withOffset:klHideUseCurrentPhone];
    [self.useCurrentPhoneNumber autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    self.joinPanelConstraint = [self.joinPanelView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                              withInset:klFakeNavBarHeight-4.];
    self.joinPanelConstraint.active = NO;
    self.joinPanelBgConstraint = [self.joinPanelBgView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                        withInset:klFakeNavBarHeight];
    self.joinPanelBgConstraint.active = NO;
    
    self.backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_ar_back"]
                                           target:self
                                         selector:@selector(onFakeBackButton:)];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"";
    [self kl_setNavigationBarColor:nil];
    [self.countryCodeButton setTitle:[KLLoginManager sharedManager].countryCode
                            forState:UIControlStateNormal];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSArray *)prepareImagesforAnimationWithName:(NSString *)name
                                         count:(NSNumber *)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[count integerValue]; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%05d", name, i];
        [array addObject:[UIImage imageNamed:imageName]];
    }
    return array;
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
        weakSelf.usePhoneButtonConstraint.constant = klShowUseCurrentPhone;
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
        weakSelf.usePhoneButtonConstraint.constant = klHideUseCurrentPhone;
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
    self.view.userInteractionEnabled = NO;
    self.submitLoadingView.hidden = NO;
    self.backButton.enabled = NO;
}

- (void)enableControls
{
    self.view.userInteractionEnabled = YES;
    self.submitLoadingView.hidden = YES;
    self.backButton.enabled = NO;
}

#pragma mark - Actions

- (IBAction)onTerms:(id)sender
{
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
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:codeVC];
    [self presentViewController:navigationVC
                       animated:YES
                     completion:^{
    }];
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
    NSArray *images = [self prepareImagesforAnimationWithName:self.tutorialAnimations[index]
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
    [self dismissViewControllerAnimated:YES
                             completion:^{
    }];
}

#pragma mark - KLChildrenViewControllerDelegate

- (void)viewController:(UIViewController *)viewController
      dissmissAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated
                             completion:^{
    }];
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
