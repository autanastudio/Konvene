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

static NSInteger klTutorialPagesCount = 4;

@interface KLLoginViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, KLCountryCodeProtocol, KLChildrenViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *tutorialPageViewController;
@property (weak, nonatomic) IBOutlet UIView *tutorialViewContainer;
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@property (nonatomic, strong) NSArray *tutorialTitles;
@property (nonatomic, strong) NSArray *tutorialTexts;
@property (nonatomic, strong) NSArray *tutorialAnimations;
@property (nonatomic, strong) NSArray *tutorialAnimationsCount;
@property (nonatomic, strong) NSArray *tutorialAnimationInset;
@property (nonatomic, strong) NSArray *tutorialFrameSize;

//Animation
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinPanelTutorialConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavBarContraint;
@property (strong, nonatomic) NSLayoutConstraint *joinPanelFakeNavBarConstraint;

@property (weak, nonatomic) IBOutlet UIView *joinPanelView;
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;

@end

static CGFloat klFakeNavBarHeight = 64.;

@implementation KLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO localize
    
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
    
    self.joinPanelFakeNavBarConstraint = [self.joinPanelView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                              withInset:klFakeNavBarHeight];
    self.joinPanelFakeNavBarConstraint.active = NO;
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
    [UIView animateWithDuration:0.25 animations:^{
        self.NavBarContraint.constant = klFakeNavBarHeight;
        self.joinPanelTutorialConstraint.active = NO;
        self.joinPanelFakeNavBarConstraint.active = YES;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideJoin
{
    [UIView animateWithDuration:0.25 animations:^{
        self.NavBarContraint.constant = 0;
        self.joinPanelTutorialConstraint.active = YES;
        self.joinPanelFakeNavBarConstraint.active = NO;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (IBAction)onTerms:(id)sender
{
}

- (IBAction)onSignUp:(id)sender
{
    [self showJoin];
//    KLSignUpViewController *signUpVC = [[KLSignUpViewController alloc] init];
//    signUpVC.kl_parentViewController = self;
//    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:signUpVC];
//    [self presentViewController:navigationVC
//                       animated:YES
//                     completion:^{
//    }];
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

@end
