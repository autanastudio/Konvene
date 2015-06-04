//
//  SFGalleryController.m
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryController.h"
#import "SFGalleryViewController.h"
#import "SFGalleryDismissingAnimator.h"
#import "SFGalleryPage.h"

@implementation SFGalleryController

- (instancetype)initWithMediaItems:(NSArray *)mediaItems
{
    self = [super init];
    if (self) {
        _galleryViewController = [[SFGalleryViewController alloc] initWithItems:mediaItems];
        self.viewControllers = @[_galleryViewController];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    SFGalleryViewController *galleryViewController;
    if ([rootViewController isKindOfClass:[SFGalleryViewController class]]) {
        galleryViewController = (SFGalleryViewController *)rootViewController;
    }
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _galleryViewController = galleryViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setGalleryViewController:(SFGalleryViewController *)galleryViewController
{
    _galleryViewController = galleryViewController;
    self.viewControllers = @[galleryViewController];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    self.galleryViewController.currentPageIndex = currentPageIndex;
}

- (void)setPresentingFromImageView:(UIImageView *)presentingFromImageView
{
    _presentingFromImageView = presentingFromImageView;
    self.galleryViewController.presentingFromImageView = presentingFromImageView;
}

- (void)setInteractivePresentationTransition:(SFGalleryPresentationAnimator *)interactivePresentationTransition
{
    _interactivePresentationTransition = interactivePresentationTransition;
    self.galleryViewController.interactivePresentationTranstion = interactivePresentationTransition;
}

#pragma mark - Custom ViewController Transitioning

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if ([animator isKindOfClass:[SFGalleryPresentationAnimator class]]) {
        SFGalleryPresentationAnimator *animatorPresent = (SFGalleryPresentationAnimator *)animator;
        if (animatorPresent.interactive) {
            return animatorPresent;
        }
        return nil;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if ([animator isKindOfClass:[SFGalleryDismissingAnimator class]]) {
        SFGalleryDismissingAnimator *animatorDismiss = (SFGalleryDismissingAnimator *)animator;
        if (animatorDismiss.interactive) {
            return animatorDismiss;
        }
        return nil;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[SFGalleryController class]]) {
        SFGalleryController *gallery = (SFGalleryController *)dismissed;
        SFGalleryViewController *galleryVC = gallery.galleryViewController;
        SFGalleryPage *page = galleryVC.currentPage;
        
        if (!galleryVC.dismissFromImageView && page.interactiveTransition.finishButtonAction) {
            return nil;
        }
        
        if (page.interactiveTransition) {
            SFGalleryDismissingAnimator *animator = page.interactiveTransition;
            animator.transitionImageView = galleryVC.dismissFromImageView;
            return animator;
        }
        
        SFGalleryDismissingAnimator *animator = [[SFGalleryDismissingAnimator alloc] init];
        animator.transitionImageView = galleryVC.dismissFromImageView;
        return animator;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[SFGalleryController class]]) {
        SFGalleryController *gallery = (SFGalleryController *)presented;
        SFGalleryViewController *galleryVC = gallery.galleryViewController;
        if (galleryVC.interactivePresentationTranstion) {
            SFGalleryPresentationAnimator *animator = galleryVC.interactivePresentationTranstion;
            animator.presentingImageView = galleryVC.presentingFromImageView;
            return animator;
        }
        SFGalleryPresentationAnimator *animator = [[SFGalleryPresentationAnimator alloc] init];
        animator.presentingImageView = galleryVC.presentingFromImageView;
        return animator;
    }
    return nil;
}


@end

@implementation UIViewController (UIViewControllerSFGalleryTransitioning)

- (void)presentGalleryController:(SFGalleryController *)galleryController
                        animated:(BOOL)animated
                      completion:(void (^)())completion
{
    galleryController.transitioningDelegate = galleryController;
    galleryController.navigationBarHidden = galleryController.prefferedNavigationBarHidden;
    [self presentViewController:galleryController animated:YES completion:completion];
}

- (void)dismissGalleryControllerAnimated:(BOOL)animated
                             toImageView:(UIImageView *)dismissImageView
                              completion:(void (^)())completion
{
    if ([self isKindOfClass:[SFGalleryController class]]) {
        SFGalleryController *gallery = (SFGalleryController *)self;
        gallery.galleryViewController.dismissFromImageView = dismissImageView;
    }
    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
