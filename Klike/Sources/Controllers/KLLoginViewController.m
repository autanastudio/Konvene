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

@end

@implementation KLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO localize
    
    self.tutorialTitles = @[@"Plan Anything",
                            @"Plan Anything",
                            @"Plan Anything",
                            @"Plan Anything"];
    self.tutorialTexts = @[@"Quickly create beautiful, interactive\nevents with friends.",
                           @"Quickly create beautiful, interactive\nevents with friends.",
                           @"Quickly create beautiful, interactive\nevents with friends.",
                           @"Quickly create beautiful, interactive\nevents with friends."];
    self.tutorialAnimations = @[@"rating", @"create_anim_real", @"create_anim_real", @"create_anim_real"];
    self.tutorialAnimationInset = @[@48, @0, @0, @0];
    self.tutorialAnimationsCount = @[@117, @106, @106, @106];
    
    self.tutorialPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
    self.tutorialPageViewController.dataSource = self;
    self.tutorialPageViewController.view.frame = self.tutorialViewContainer.bounds;
    [self.tutorialPageViewController setViewControllers:@[[self viewControllerAtIndex:0]]
                                              direction:UIPageViewControllerNavigationDirectionForward
                                               animated:NO
                                             completion:nil];
    [self addChildViewController:self.tutorialPageViewController];
    [self.tutorialViewContainer addSubview:[self.tutorialPageViewController view]];
    [self.tutorialPageViewController didMoveToParentViewController:self];
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

#pragma mark - Actions

- (IBAction)onTerms:(id)sender
{
}

- (IBAction)onSignUp:(id)sender
{
    KLSignUpViewController *signUpVC = [[KLSignUpViewController alloc] init];
    signUpVC.kl_parentViewController = self;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self presentViewController:navigationVC
                       animated:YES
                     completion:^{
    }];
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
                                                         animationDuration:images.count/25
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
