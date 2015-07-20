//
//  SFGalleryController.h
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFGalleryDismissingAnimator.h"

typedef void (^SFImageViewPresentFinishedBlock)(NSInteger currentIndex,
                                                UIImage *image,
                                                SFGalleryDismissingAnimator *interactiveTransition);

@class SFGalleryViewController, SFGalleryPresentationAnimator, SFGalleryViewController;

@interface SFGalleryController : UINavigationController <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) SFGalleryViewController *galleryViewController;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UIImageView *presentingFromImageView;
@property (nonatomic, strong) SFGalleryPresentationAnimator  *interactivePresentationTransition;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL prefferedNavigationBarHidden;

@property (nonatomic, strong) SFImageViewPresentFinishedBlock finishedBlock;

- (instancetype)initWithMediaItems:(NSArray *)mediaItems;

@end

@interface UIViewController (UIViewControllerSFGalleryTransitioning)

- (void)presentGalleryController:(SFGalleryController *)galleryController
                        animated:(BOOL)animated
                      completion:(void (^)())completion;

- (void)dismissGalleryControllerAnimated:(BOOL)animated
                             toImageView:(UIImageView *)dismissImageView
                              completion:(void (^)())completion;

@end
