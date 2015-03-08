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

@interface KLLoginViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *tutorialPageViewController;
@property (weak, nonatomic) IBOutlet UIView *tutorialViewContainer;

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
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)onSignUp:(id)sender
{
    KLSignUpViewController *signUpVC = [[KLSignUpViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self presentViewController:navigationVC animated:YES completion:^{
        
    }];
}

- (IBAction)onPhoneCountryCode:(id)sender
{
    KLCountryCodeViewCntroller *codeVC = [[KLCountryCodeViewCntroller alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:codeVC];
    [self presentViewController:navigationVC animated:YES completion:^{
        
    }];
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
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
