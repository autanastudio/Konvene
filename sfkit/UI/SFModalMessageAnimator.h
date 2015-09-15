//
//  SFModalMessageAnimator.h
//  SFKit
//
//  Created by Yarik Smirnov on 16/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFModalMessageAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL dismissing;

+ (void)animateView:(UIView *)view
        inContainer:(UIView *)containerView
            dismiss:(BOOL)dismissing
         withChrome:(BOOL)shouldProvideChrome
         completion:(void (^)())completion;

@end
