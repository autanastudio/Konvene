//
//  SFGalleryDismissingAnimator.h
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

UIImage *SFImageFromView(UIView *view);
UIImage *SFDefaultImageForFrame(CGRect frame);

@import MediaPlayer;
@interface SFGalleryDismissingAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong)    MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong)    UIImageView *transitionImageView;
@property (nonatomic,assign)    CGPoint changedPoint;
@property (nonatomic,assign)    CGFloat orientationTransformBeforeDismiss;
@property (nonatomic,assign)    BOOL interactive;
@property (nonatomic,assign)    BOOL finishButtonAction;

@property (nonatomic,assign)    id <UIViewControllerContextTransitioning> context;

@end
