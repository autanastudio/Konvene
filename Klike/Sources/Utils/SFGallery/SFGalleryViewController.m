//
//  SFGalleryViewController.m
//  Livid
//
//  Created by Sibagatov Ildar on 21.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryViewController.h"
#import "SFGalleryDataSource.h"
#import "SFGalleryItem.h"
#import "SFGalleryPage.h"
#import "SFGalleryController.h"

@interface SFGalleryViewController ()

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) SFGalleryDataSource *dataSource;
@property (nonatomic, strong) NSArray *mediaItems;
@property (nonatomic, readonly) SFGalleryController *galleryController;

@end

@implementation SFGalleryViewController

- (instancetype)initWithItems:(NSArray *)mediaItems
{
    self = [super init];
    if (self) {
        _mediaItems = mediaItems;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:@{ UIPageViewControllerOptionInterPageSpacingKey : @20.0f }];
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    [self.view addSubview:self.pageController.view];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(dismissGallery)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.currentNavigationItem.leftBarButtonItem = cancelItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataSource == nil) {
        [self attachDataSource];
    }
    [self.dataSource loadContentIfNeeded:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Data Source Initialization

- (void)attachDataSource
{
    self.dataSource = [self buildDataSource];
    self.dataSource.delegate = self;
    self.pageController.dataSource = self.dataSource;
    self.pageController.delegate = self.dataSource;
}

- (SFGalleryDataSource *)buildDataSource
{
    SFGalleryDataSource *dataSource = [[SFGalleryDataSource alloc] init];
    dataSource.pageIndex = self.currentPageIndex;
    dataSource.items = self.mediaItems;
    return dataSource;
}

#pragma mark - General Methods

- (SFGalleryPage *)currentPage
{
    return self.pageController.viewControllers.firstObject;
}

- (NSInteger)currentPageIndex
{
    if (self.currentPage) {
        return self.currentPage.index;
    }
    return _currentPageIndex;
}

- (SFGalleryController *)galleryController
{
    if ([self.navigationController isKindOfClass:[SFGalleryController class]]) {
        return (SFGalleryController *)self.navigationController;
    }
    return nil;
}

- (void)dismissGallery
{
    SFGalleryPage *imageViewer = self.currentPage;
//    if (imageViewer.moviePlayer) {
//        [imageViewer removeAllMoviePlayerViewsAndNotifications];
//    }
    SFGalleryDismissingAnimator *dismissTransiton = [[SFGalleryDismissingAnimator alloc] init];
    dismissTransiton.orientationTransformBeforeDismiss = [(NSNumber *)[self.navigationController.view valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    dismissTransiton.finishButtonAction = YES;
    imageViewer.interactiveTransition = dismissTransiton;
    
    SFGalleryController *gallery = self.galleryController;
    if (gallery.finishedBlock) {
        gallery.finishedBlock(self.currentPageIndex, imageViewer.imageView.image, dismissTransiton);
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - SFGalleryDataSource Delegate

- (void)dataSource:(SFGalleryDataSource *)dataSource didLoadContentWithError:(NSError *)error
{
    [self.pageController setViewControllers:@[[self.dataSource pageForIndex:self.dataSource.pageIndex]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

#pragma mark - SFGalleryPage Delegate

- (void)galleryMediaPage:(SFGalleryPage *)viewController handleDoubleTap:(CGPoint)tapPoint
{
    if (self.currentPage.media.type == SFGalleryItemTypeImage) {
        [viewController zoomToPoint:tapPoint];
    }
}

@end
