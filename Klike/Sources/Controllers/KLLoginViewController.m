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

@interface KLLoginViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, KLCountryCodeProtocol>

@property (nonatomic, strong) UIPageViewController *tutorialPageViewController;
@property (weak, nonatomic) IBOutlet UIView *tutorialViewContainer;
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation KLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tutorialPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
    self.tutorialPageViewController.dataSource = self;
    self.tutorialPageViewController.view.frame = self.tutorialViewContainer.bounds;
    KLTutorialPageViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.tutorialPageViewController setViewControllers:viewControllers
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

#pragma mark - Actions

- (IBAction)onTerms:(id)sender
{
//    KLLoginDetailsViewController *detailsViewController = [[KLLoginDetailsViewController alloc] init];
//    [self.navigationController pushViewController:detailsViewController
//                                         animated:YES];
}

- (IBAction)onSignUp:(id)sender
{
    KLSignUpViewController *signUpVC = [[KLSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC
                                         animated:YES];
}

- (IBAction)onPhoneCountryCode:(id)sender
{
    KLCountryCodeViewCntroller *codeVC = [[KLCountryCodeViewCntroller alloc] init];
    codeVC.delegate = self;
    [self.navigationController pushViewController:codeVC
                                         animated:YES];
}

#pragma mark - UIPageViewControllerDataSource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(KLTutorialPageViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(KLTutorialPageViewController *)viewController index];
    index++;
    if (index == 5) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (KLTutorialPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    KLTutorialPageViewController *childViewController = [KLTutorialPageViewController
                                                   tutorialPageControllerWithTitle:@"Plan Anything"
                                                   text:@"Quickly create beautiful, \ninteractive events with friends."
                                                   animationImages:nil];
    childViewController.index = index;
    return childViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - KLCountryCodeProtocol methods

- (void)dissmissCoutryCodeViewControllerWithnewCode:(NSString *)code
{
    [KLLoginManager sharedManager].countryCode = code;
    [self.countryCodeButton setTitle:code
                            forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
