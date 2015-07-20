//
//  KLSegmentedController.m
//  Klike
//
//  Created by admin on 09/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSegmentedController.h"

@interface KLSegmentedController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIView *segmentedContollerLine;
@property (nonatomic, strong) UIPageViewController *pageController;
@end

@implementation KLSegmentedController

- (id)initWithChildControllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        _childControllers = [controllers copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(self.childControllers.count, @"At least 1 child viewcontroller required");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentedContollerLine = [[UIView alloc] init];
    self.segmentedContollerLine.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
    
    self.segmentedControl = [KLSegmentedControl kl_segmentedControl];
    for (int i=0; i<self.childControllers.count; i++) {
        UIViewController *vc = self.childControllers[i];
        [self.segmentedControl insertSegmentWithTitle:[vc title]
                                              atIndex:i
                                             animated:NO];
    }
    [self.segmentedControl setContentOffset:CGSizeMake(0, -5)];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(onSegmentValueChanged)
                    forControlEvents:UIControlEventValueChanged];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController setViewControllers:@[self.childControllers.firstObject]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self layout];
}

- (void)onSegmentValueChanged
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    UIViewController *targetVC = self.childControllers[index];
    UIViewController *currentVC = self.pageController.viewControllers.firstObject;
    
    UIPageViewControllerNavigationDirection direction;
    if (index < [self.childControllers indexOfObject:currentVC]) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    [self.pageController setViewControllers:@[targetVC]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}

- (void)updateSegmentedControlTitles
{
    for (int i=0; i<self.childControllers.count; i++) {
        UIViewController *vc = self.childControllers[i];
        [self.segmentedControl setTitle:[vc title] forSegmentAtIndex:i];
    }
}

#pragma mark - Layout

- (void)layout
{
    [self.view addSubview:self.segmentedContollerLine];
    [self.segmentedContollerLine autoSetDimension:ALDimensionHeight
                                           toSize:3.];
    [self.segmentedContollerLine autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                  withInset:0.];
    [self.segmentedContollerLine autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                  withInset:0.];
    
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl autoSetDimension:ALDimensionHeight
                                     toSize:48];
    [self.segmentedControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                    excludingEdge:ALEdgeBottom];
    [self.segmentedContollerLine autoPinEdge:ALEdgeBottom
                                      toEdge:ALEdgeBottom
                                      ofView:self.segmentedControl
                                  withOffset:0.];
    
    [self.view addSubview:self.pageController.view];
    [self.pageController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                       excludingEdge:ALEdgeTop];
    [self.pageController.view autoPinEdge:ALEdgeTop
                                   toEdge:ALEdgeBottom
                                   ofView:self.segmentedControl];
}

#pragma mark - Page View Controller

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.childControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    index--;
    return self.childControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.childControllers indexOfObject:viewController];
    if (index == self.childControllers.count-1) {
        return nil;
    }
    index++;
    return self.childControllers[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    NSInteger index = [self.childControllers indexOfObject:pageViewController.viewControllers.firstObject];
    [self.segmentedControl setSelectedSegmentIndex:index];
}

@end
