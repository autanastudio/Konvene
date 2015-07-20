//
//  SFGalleryPage.h
//  Livid
//
//  Created by Sibagatov Ildar on 23.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFGalleryPresentationAnimator.h"
#import "SFGalleryDismissingAnimator.h"
#import "SFGalleryItem.h"

@class SFGalleryPage;
@protocol SFGalleryPageDelegate <NSObject>
@optional
- (void)galleryMediaPage:(SFGalleryPage *)viewController handleSingleTap:(CGPoint)tapPoint;
- (void)galleryMediaPage:(SFGalleryPage *)viewController handleDoubleTap:(CGPoint)tapPoint;
@end

@interface SFGalleryPage : UIViewController
@property (nonatomic,strong) SFGalleryDismissingAnimator *interactiveTransition;
@property (nonatomic, weak) SFGalleryItem *media;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIImageView *playIcon;

@property (nonatomic, weak) id<SFGalleryPageDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithMedia:(SFGalleryItem *)media atPage:(NSUInteger)pageIndex;

- (void)zoomToPoint:(CGPoint)targetPoint;
- (BOOL)zoomOut;

@end
