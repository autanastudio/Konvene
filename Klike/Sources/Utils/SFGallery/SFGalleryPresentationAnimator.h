//
//  SFGalleryPresentationAnimator.h
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFUIImageViewContentViewAnimation.h"

@interface SFGalleryPresentationAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong)    SFUIImageViewContentViewAnimation *transitionImageView;
@property (nonatomic,strong)    UIImageView *presentingImageView;
@property (nonatomic,assign)    CGFloat angle;
@property (nonatomic,assign)    CGFloat scale;
@property (nonatomic,assign)    CGPoint changedPoint;
@property (nonatomic,assign)    id <UIViewControllerContextTransitioning> context;
@property (nonatomic,assign)    BOOL interactive;

@end
