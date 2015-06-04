//
//  SFGalleryViewController.h
//  Livid
//
//  Created by Sibagatov Ildar on 21.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFGalleryPresentationAnimator.h"
#import "SFGalleryDataSource.h"
#import "SFGalleryPage.h"

@interface SFGalleryViewController : UIViewController <SFGalleryDataSourceDelegate, SFGalleryPageDelegate>
@property (nonatomic, readonly) NSArray *mediaItems;
@property (nonatomic, readonly) SFGalleryPage *currentPage;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, readonly) UIPageViewController *pageController;

@property (nonatomic, strong) UIImageView *presentingFromImageView;
@property (nonatomic, strong) UIImageView *dismissFromImageView;
@property (nonatomic, strong) SFGalleryPresentationAnimator *interactivePresentationTranstion;

- (instancetype)initWithItems:(NSArray *)mediaItems;

- (void)attachDataSource;
- (SFGalleryDataSource *)buildDataSource;
- (SFGalleryDataSource *)dataSource;

- (void)dismissGallery;

@end
