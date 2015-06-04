//
//  SFImageViewPresenter.h
//  Livid
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFGalleryDismissingAnimator.h"
#import "SFGalleryPresentationAnimator.h"
#import "SFGalleryController.h"

@interface SFImageViewPresenter : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic)       BOOL shoudlUsePanGestureReconizer;
/**
 *  set your Current ViewController
 */
@property (nonatomic,strong) UIViewController *viewController;
/**
 *  set your the Data Source
 */
@property (nonatomic,strong) NSArray *galleryItems;
/**
 *  set the currentIndex
 */
@property (nonatomic)        NSInteger currentImageIndex;

@property (nonatomic, copy) SFImageViewPresentFinishedBlock finishedBlock;

@property (nonatomic,strong) SFGalleryPresentationAnimator *presenter;

-(void)setInseractiveGalleryPresentionWithItems:(NSArray*)galleryItems
                              currentImageIndex:(NSInteger)currentImageIndex
                          currentViewController:(UIViewController*)viewController
                                 finishCallback:(SFImageViewPresentFinishedBlock)finishBlock;

@end
