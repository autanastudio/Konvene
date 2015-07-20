//
//  SFGalleryDismissingAnimator.m
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryDismissingAnimator.h"
#import "SFUIImageViewContentViewAnimation.h"
#import "SFGalleryController.h"
#import "SFGalleryViewController.h"
#import "SFGalleryPage.h"

@import AVFoundation;

UIImage *SFImageFromView(UIView *view)
{
    CGFloat scale = 1.0;
    if([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        CGFloat tmp = UIScreen.mainScreen.scale;
        if (tmp > 1.5) {
            scale = 2.0;
        }
    }
    if(scale > 1.5) {
        UIGraphicsBeginImageContextWithOptions([view bounds].size, NO, scale);
    } else {
        UIGraphicsBeginImageContext([view bounds].size);
    }
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

UIImage *SFDefaultImageForFrame(CGRect frame)
{
    UIView *view = [UIView.alloc initWithFrame:frame];
    view.backgroundColor = UIColor.whiteColor;
    return  SFImageFromView(view);
}

@interface SFGalleryDismissingAnimator ()
@property (nonatomic,assign) CGFloat toTransform;
@property (nonatomic,assign) CGFloat startTransform;
@property (nonatomic,assign) CGRect startFrame;
@property (nonatomic,assign) CGPoint startCenter;

@property (nonatomic,assign) CGRect navFrame;
@property (nonatomic,assign) BOOL wrongTransform;

@property (nonatomic,assign) BOOL hasActiveVideo;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) SFUIImageViewContentViewAnimation *cellImageSnapshot;
@end

@implementation SFGalleryDismissingAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    id toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    SFGalleryController *fromVC =
        (SFGalleryController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.alpha = 0;
    
    SFGalleryViewController *imageViewer  = fromVC.galleryViewController;
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIImage *image = imageViewer.currentPage.imageView.image;
    if(!image){
        image = SFDefaultImageForFrame(fromVC.view.frame);
    }
    
    SFUIImageViewContentViewAnimation *cellImageSnapshot =
        [[SFUIImageViewContentViewAnimation alloc] initWithFrame:fromVC.view.bounds];
    cellImageSnapshot.image = image;
    CGRect aspectRatioRect = AVMakeRectWithAspectRatioInsideRect(cellImageSnapshot.sf_image.size,fromVC.view.bounds);
    cellImageSnapshot.frame = aspectRatioRect;
    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
    
    [imageViewer.pageController.view setHidden:YES];
    
    [toVC view].frame = [transitionContext finalFrameForViewController:toVC];
    [toVC view].alpha = 0;
    
    UIView *backView = [UIView.alloc initWithFrame:fromVC.view.frame];
    backView.backgroundColor = [UIColor blackColor];
    
    [containerView addSubview:backView];
    [containerView addSubview:[toVC view]];
    [containerView addSubview:cellImageSnapshot];
    
    self.toTransform = [(NSNumber *)[[toVC view] valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    self.startTransform = [(NSNumber *)[containerView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    
    if ([toVC view].frame.size.width >[toVC view].frame.size.height && self.toTransform ==0) {
        self.toTransform = self.startTransform;
    }
    if (self.toTransform != self.orientationTransformBeforeDismiss) {
        CGRect aspectRatioRect = AVMakeRectWithAspectRatioInsideRect(cellImageSnapshot.sf_image.size,
                                                                     fromVC.view.bounds);
        cellImageSnapshot.frame = aspectRatioRect;
        cellImageSnapshot.transform = CGAffineTransformMakeRotation(self.orientationTransformBeforeDismiss);
        cellImageSnapshot.center = [UIApplication sharedApplication].keyWindow.center;
        self.startFrame = cellImageSnapshot.bounds;
    }
    
    CGFloat delayTime  = 0.0;
    if (self.toTransform != self.orientationTransformBeforeDismiss) {
        [UIView animateWithDuration:0.2 animations:^{
            cellImageSnapshot.transform = CGAffineTransformMakeRotation(self.toTransform);
        }];
        delayTime =0.2;
    }
    double delayInSeconds = delayTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.transitionImageView.hidden = YES;
            
            [UIView animateWithDuration:duration animations:^{
                backView.alpha =0;
                [toVC view].alpha = 1;
                
                cellImageSnapshot.frame = [containerView convertRect:self.transitionImageView.frame
                                                           fromView:self.transitionImageView.superview];
                
                if (self.transitionImageView.contentMode == UIViewContentModeScaleAspectFit) {
                    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
                }
                if (self.transitionImageView.contentMode == UIViewContentModeScaleAspectFill) {
                    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFill;
                }
            } completion:^(BOOL finished) {
                self.transitionImageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            
        });
    });
    
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    self.context = transitionContext;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    SFGalleryController *fromVC =
        (SFGalleryController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    SFGalleryViewController *imageViewer  = fromVC.galleryViewController;
    
    self.containerView = [transitionContext containerView];
    
    SFGalleryPage *imageViewerCurrent = imageViewer.currentPage;
    UIImage *image = imageViewerCurrent.imageView.image;
    
    self.cellImageSnapshot = [[SFUIImageViewContentViewAnimation alloc] initWithFrame:fromVC.view.bounds];
    self.cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
    
    if (!image) {
        image = SFDefaultImageForFrame(fromVC.view.frame);
    }
    
    self.cellImageSnapshot.image = image;
    [self.cellImageSnapshot setFrame:AVMakeRectWithAspectRatioInsideRect(image.size,fromVC.view.bounds)];
    self.startFrame = self.cellImageSnapshot.frame;
    self.startCenter = self.cellImageSnapshot.center;
    
    imageViewer.pageController.view.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    fromVC.view.alpha = 0;
    
    self.backView = [UIView.alloc initWithFrame:[toVC view].frame];
    self.backView.backgroundColor = [UIColor blackColor];
    
    [self.containerView addSubview:[toVC view]];
    [self.containerView addSubview:self.backView];
    
    self.toTransform = [(NSNumber *)[[toVC view] valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    self.startTransform = [(NSNumber *)[self.containerView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    
    self.wrongTransform = NO;
    if (toVC.view.frame.size.width > toVC.view.frame.size.height && self.toTransform ==0) {
        self.toTransform = self.startTransform;
        self.wrongTransform = YES;
    }
    
//    if (imageViewerCurrent.isPlayingVideo && imageViewerCurrent.moviePlayer) {
//        self.moviePlayer = imageViewerCurrent.moviePlayer;
//        [self.moviePlayer.view setFrame:AVMakeRectWithAspectRatioInsideRect(imageViewerCurrent.moviePlayer.naturalSize,fromVC.view.bounds)];
//        
//        self.startFrame = self.moviePlayer.view.frame;
//        
//        [self.containerView addSubview:self.moviePlayer.view];
//        self.transitionImageView.hidden = YES;
//    } else {
        [self.containerView addSubview:self.cellImageSnapshot];
        self.transitionImageView.hidden = YES;
//    }
    self.navFrame = fromVC.navigationBar.frame;
    if (self.toTransform != self.orientationTransformBeforeDismiss && !self.wrongTransform) {
//        if (self.moviePlayer) {
//            [self.moviePlayer.view setFrame:AVMakeRectWithAspectRatioInsideRect(imageViewerCurrent.moviePlayer.naturalSize,CGRectMake(0, 0, fromVC.view.bounds.size.width, fromVC.view.bounds.size.height))];
//            self.moviePlayer.view.transform = CGAffineTransformMakeRotation(self.orientationTransformBeforeDismiss);
//            self.moviePlayer.view.center = UIApplication.sharedApplication.keyWindow.center;
//            self.startFrame = self.moviePlayer.view.bounds;
//            self.startCenter = self.moviePlayer.view.center;
//        } else {
            CGRect aspectRatioRect = AVMakeRectWithAspectRatioInsideRect( image.size, fromVC.view.bounds);
            [self.cellImageSnapshot setFrame:aspectRatioRect];
            self.cellImageSnapshot.transform = CGAffineTransformMakeRotation(self.orientationTransformBeforeDismiss);
            self.cellImageSnapshot.center = UIApplication.sharedApplication.keyWindow.center;
            self.startFrame = self.cellImageSnapshot.bounds;
            self.startCenter = self.cellImageSnapshot.center;
//        }
        self.startTransform = self.orientationTransformBeforeDismiss;
    }
}

-(void)updateInteractiveTransition:(CGFloat)percentComplete{
    [super updateInteractiveTransition:percentComplete];
    
    self.backView.alpha = 1.1 - percentComplete;
    if (self.moviePlayer.playbackState != MPMoviePlaybackStateStopped &&
        self.moviePlayer.playbackState != MPMoviePlaybackStatePaused)
    {
        if (self.toTransform != self.orientationTransformBeforeDismiss) {
            if (self.orientationTransformBeforeDismiss < 0) {
                self.moviePlayer.view.center = CGPointMake(self.moviePlayer.view.center.x - self.changedPoint.y,
                                                           self.moviePlayer.view.center.y + self.changedPoint.x);
            } else {
                self.moviePlayer.view.center = CGPointMake(self.moviePlayer.view.center.x + self.changedPoint.y,
                                                           self.moviePlayer.view.center.y - self.changedPoint.x);
            }
        } else {
            self.moviePlayer.view.frame = CGRectMake(self.moviePlayer.view.frame.origin.x - self.changedPoint.x,
                                                     self.moviePlayer.view.frame.origin.y - self.changedPoint.y,
                                                     self.moviePlayer.view.frame.size.width,
                                                     self.moviePlayer.view.frame.size.height);
        }
    } else {
        if (self.toTransform != self.orientationTransformBeforeDismiss && !self.wrongTransform) {
            if (self.orientationTransformBeforeDismiss < 0) {
                self.cellImageSnapshot.center = CGPointMake(self.cellImageSnapshot.center.x - self.changedPoint.y,
                                                            self.cellImageSnapshot.center.y + self.changedPoint.x);
            } else {
                self.cellImageSnapshot.center = CGPointMake(self.cellImageSnapshot.center.x + self.changedPoint.y,
                                                            self.cellImageSnapshot.center.y - self.changedPoint.x);
            }
        } else {
            self.cellImageSnapshot.frame = CGRectMake(self.cellImageSnapshot.frame.origin.x - self.changedPoint.x,
                                                      self.cellImageSnapshot.frame.origin.y - self.changedPoint.y,
                                                      self.cellImageSnapshot.frame.size.width,
                                                      self.cellImageSnapshot.frame.size.height);
        }
    }
}

-(void)finishInteractiveTransition{
    [super finishInteractiveTransition];
    
    CGFloat delayTime  = 0.0;
    if (self.toTransform != self.orientationTransformBeforeDismiss &&
        self.transitionImageView  && !self.wrongTransform)
    {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.moviePlayer) {
                self.moviePlayer.view.transform = CGAffineTransformMakeRotation(self.toTransform);
            } else {
                self.cellImageSnapshot.transform = CGAffineTransformMakeRotation(self.toTransform);
            }
        }];
        delayTime =0.2;
    }
    double delayInSeconds = delayTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (self.transitionImageView.contentMode == UIViewContentModeScaleAspectFill) {
            CGRect forFrame = [self.containerView convertRect:self.transitionImageView.frame
                                                    fromView:self.transitionImageView.superview];
            [self.cellImageSnapshot animateToViewMode:UIViewContentModeScaleAspectFill
                                             forFrame:forFrame
                                         withDuration:0.3
                                           afterDelay:0
                                             finished:nil];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.cellImageSnapshot.clipsToBounds = self.transitionImageView.clipsToBounds;
            self.cellImageSnapshot.layer.cornerRadius = self.transitionImageView.layer.cornerRadius;
            
            if (self.moviePlayer) {
                self.moviePlayer.view.frame = [self.containerView convertRect:self.transitionImageView.frame
                                                                     fromView:self.transitionImageView.superview];
            } else {
                if (!self.transitionImageView) {
                    CGPoint newPoint = self.startCenter;
                    if (self.cellImageSnapshot.center.x > self.startCenter.x) {
                        newPoint.x = (self.cellImageSnapshot.center.x +
                                      fabs(self.cellImageSnapshot.center.x - self.startCenter.x) * 4);
                    } else {
                        newPoint.x = (self.cellImageSnapshot.center.x -
                                      fabs(self.cellImageSnapshot.center.x - self.startCenter.x) * 4);
                    }
                    if (self.cellImageSnapshot.center.y > self.startCenter.y) {
                        newPoint.y = (self.cellImageSnapshot.center.y +
                                      fabs(self.cellImageSnapshot.center.y - self.startCenter.y) * 4);
                    } else {
                        newPoint.y = (self.cellImageSnapshot.center.y -
                                      fabs(self.cellImageSnapshot.center.y - self.startCenter.y) * 4);
                    }
                    self.cellImageSnapshot.center = newPoint;
                } else {
                    if (self.transitionImageView.contentMode == UIViewContentModeScaleAspectFit) {
                        CGRect snapshotFrame = [self.containerView convertRect:self.transitionImageView.frame
                                                                      fromView:self.transitionImageView.superview];
                        self.cellImageSnapshot.frame = snapshotFrame;
                    }
                }
            }
            
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            self.transitionImageView.hidden = NO;
            [self.cellImageSnapshot removeFromSuperview];
            [self.backView removeFromSuperview];
            [self.context completeTransition:!self.context.transitionWasCancelled];
            self.context = nil;
        }];
    });
    
}


-(void)cancelInteractiveTransition{
    [super cancelInteractiveTransition];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.moviePlayer) {
            if (self.toTransform != self.orientationTransformBeforeDismiss) {
                self.moviePlayer.view.center = CGPointMake(self.moviePlayer.view.bounds.size.height / 2,
                                                           self.moviePlayer.view.center.y);
            } else {
                self.moviePlayer.view.frame = self.startFrame;
            }
        } else {
            if (self.toTransform != self.orientationTransformBeforeDismiss) {
                self.cellImageSnapshot.center = UIApplication.sharedApplication.keyWindow.center;
            } else {
                self.cellImageSnapshot.frame = self.startFrame;
            }
        }
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
        self.transitionImageView.hidden = NO;
        [self.cellImageSnapshot removeFromSuperview];
        [self.backView removeFromSuperview];
        
        SFGalleryController *fromVC =
            (SFGalleryController *)[self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
        if (self.moviePlayer) {
            if (self.toTransform != self.orientationTransformBeforeDismiss) {
                self.moviePlayer.view.transform = CGAffineTransformMakeRotation(self.toTransform);
                self.moviePlayer.view.center = CGPointMake(self.moviePlayer.view.bounds.size.width / 2,
                                                           self.moviePlayer.view.bounds.size.height / 2);
            } else {
                self.moviePlayer.view.bounds = fromVC.view.bounds;
            }
        }
        
        fromVC.view.alpha = 1;
        
        SFGalleryViewController *imageViewer  = fromVC.galleryViewController;
        imageViewer.pageController.view.hidden = NO;
        
        if (self.moviePlayer) {
            SFGalleryPage *page = imageViewer.currentPage;
            [page.view insertSubview:self.moviePlayer.view atIndex:2];
        }
        
        [UIApplication.sharedApplication.keyWindow addSubview:fromVC.view];
        self.moviePlayer = nil;
        
        [self.context completeTransition:NO];
        if (self.moviePlayer) {
            [UIView performWithoutAnimation:^{
                [self doOrientationwithFromViewController:fromVC];
            }];
        } else {
            float OSVersion = [UIDevice currentDevice].systemVersion.floatValue;
            if (OSVersion < 8.0) {
                [self doOrientationwithFromViewController:fromVC];
            } else {
                [UIView performWithoutAnimation:^{
                    [self doOrientationwithFromViewController:fromVC];
                }];
            }
        }
    }];
}


-(void)doOrientationwithFromViewController:(UINavigationController*)fromVC{
    
    float OSVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (OSVersion < 8.0) {
        fromVC.view.transform = CGAffineTransformMakeRotation(self.startTransform);
        fromVC.view.center = UIApplication.sharedApplication.keyWindow.center;
    }
    if (self.toTransform != self.orientationTransformBeforeDismiss) {
        
        NSData *decodedData = [NSData.alloc initWithBase64EncodedString:@"b3JpZW50YXRpb24=" options:0];
        NSString *status = [NSString.alloc initWithData:decodedData encoding:NSUTF8StringEncoding];
        
        [UIDevice.currentDevice setValue:@(UIInterfaceOrientationPortrait) forKey:status];
        if (self.orientationTransformBeforeDismiss >0) {
            [UIDevice.currentDevice setValue:@(UIInterfaceOrientationLandscapeRight) forKey:status];
        }else{
            [UIDevice.currentDevice setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:status];
        }
    }else{
        fromVC.navigationBar.frame = CGRectMake(0, 0, fromVC.navigationBar.frame.size.width, 64);
        if (fromVC.traitCollection.userInterfaceIdiom != UIUserInterfaceIdiomPad) {
            if (self.orientationTransformBeforeDismiss != 0) {
                fromVC.navigationBar.frame = CGRectMake(0, 0, fromVC.navigationBar.frame.size.width, 52);
            }
        }
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

@end
