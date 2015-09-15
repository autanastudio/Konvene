//
//  SFModalMessageAnimator.m
//  SFKit
//
//  Created by Yarik Smirnov on 16/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFModalMessageAnimator.h"

@implementation SFModalMessageAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.dismissing) {
        return .2;
    }
    return .3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIView *animationView;
    if (!self.dismissing) {
        animationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        animationView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    [self.class animateView:animationView
                inContainer:containerView
                    dismiss:NO
                 withChrome:NSClassFromString(@"UIPresentationController") != nil
                 completion:^{
                     [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                 }];
}

+ (void)animateView:(UIView *)view
        inContainer:(UIView *)containerView
            dismiss:(BOOL)dismissing
         withChrome:(BOOL)shouldProvideChrome
         completion:(void (^)())completion
{
    UIView *chrome;
    if (!dismissing) {
        
        if (shouldProvideChrome) {
            chrome = [[UIView alloc] initWithFrame:containerView.bounds];
            [containerView addSubview:chrome];
            chrome.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            chrome.alpha = 0;
            chrome.tag = 0xABC;
        }
        
        [containerView addSubview:view];
        view.alpha = 0;
        
        view.transform = CGAffineTransformMakeScale(.5, .5);
        
        [UIView animateWithDuration:.1
                              delay:0
                            options:(UIViewAnimationOptionBeginFromCurrentState|
                                     UIViewAnimationOptionCurveEaseOut)
                         animations:^{
                             view.alpha = 1;
                             chrome.alpha = 1;
                         } completion:NULL];
        
        [UIView animateWithDuration:.3
                              delay:0
             usingSpringWithDamping:.7
              initialSpringVelocity:0
                            options:(UIViewAnimationOptionBeginFromCurrentState|
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    } else {
        chrome = [containerView viewWithTag:0xABC];
        [UIView animateWithDuration:.2
                              delay:0
                            options:(UIViewAnimationOptionBeginFromCurrentState|
                                     UIViewAnimationOptionCurveEaseOut)
                         animations:^{
                             view.alpha = 0;
                             chrome.alpha = 0;
                             view.transform = CGAffineTransformMakeScale(.3, .3);
                         } completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             if (completion) {
                                 completion();
                             }
                         }];
    }
}

@end
