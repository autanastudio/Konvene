//
//  SFGalleryPage.m
//  Livid
//
//  Created by Sibagatov Ildar on 23.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryPage.h"
@import AVFoundation;
@import MediaPlayer;

@interface SFGalleryPage () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerVC;

@end

@implementation SFGalleryPage

- (instancetype)initWithMedia:(SFGalleryItem *)media atPage:(NSUInteger)pageIndex
{
    self = [super init];
    if (self) {
        _media = media;
        _index = pageIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layout];
    [self configureWithGivenMedia];
}

- (void)configureWithGivenMedia
{
    self.playIcon.hidden = self.media.type == SFGalleryItemTypeImage;
    if (self.media == nil) {
        self.imageView.image = nil;
        return;
    } else {
        __weak __typeof(self)weakSelf = self;
        [self.activityIndicator startAnimating];
        NSString *thumbKey = self.media.thumbnailURL.absoluteString;
        UIImage *placeholder = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:thumbKey];
        NSURL *url = self.media.type == SFGalleryItemTypeImage ? self.media.URL : self.media.thumbnailURL;
        if (url) {
            
            [self.imageView sd_setImageWithURL:url
                              placeholderImage:placeholder
                                     completed:
             ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 [weakSelf.activityIndicator stopAnimating];
             }];
        }
        else {
            self.imageView.image = self.media.image;
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        }
    }
}

- (MPMoviePlayerViewController *)moviePlayerVC
{
    if (self.media.type == SFGalleryItemTypeVideo && !_moviePlayerVC) {
        _moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:self.media.URL];
    }
    return _moviePlayerVC;
}

- (void)tooglePlaybackState
{
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerVC];
    [self.moviePlayerVC.moviePlayer play];
}

- (void)layout
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.hidesWhenStopped =YES;
    [self.scrollView addSubview:self.activityIndicator];
    
    self.playIcon = [[UIImageView alloc] init];
    self.playIcon.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.playIcon];
    [self.playIcon autoCenterInSuperview];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.view addGestureRecognizer:singleTapGesture];
}

#pragma mark - Logic

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(galleryMediaPage:handleSingleTap:)]) {
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        touchPoint = [self.scrollView convertPoint:touchPoint fromView:self.imageView];
        [self.delegate galleryMediaPage:self handleSingleTap:touchPoint];
    }
    
    if (self.media.type == SFGalleryItemTypeVideo) {
        [self tooglePlaybackState];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(galleryMediaPage:handleDoubleTap:)]) {
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        touchPoint = [self.scrollView convertPoint:touchPoint fromView:self.imageView];
        [self.delegate galleryMediaPage:self handleDoubleTap:touchPoint];
    }
}

- (BOOL)zoomOut
{
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0f animated:YES];
        return YES;
    }
    return NO;
}

- (void)zoomToPoint:(CGPoint)targetPoint
{
    if (self.imageView.image == nil)
        return;
    
    if ([self zoomOut]) {
        return;
    }
    
    [self centerImageView];
    
    CGRect zoomRect;
    CGFloat newZoomScale = (self.scrollView.maximumZoomScale);
    zoomRect.size.height = [self.imageView frame].size.height / newZoomScale;
    zoomRect.size.width  = [self.imageView frame].size.width  / newZoomScale;
    zoomRect.origin.x = targetPoint.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y = targetPoint.y - ((zoomRect.size.height / 2.0));
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (void)centerImageView
{
    if (self.imageView.image == nil) {
        return;
    }
    
    CGRect frame  = AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size,
                                                        CGRectMake(0, 0, self.scrollView.contentSize.width,
                                                                   self.scrollView.contentSize.height));
    if (self.scrollView.contentSize.width == 0.0f && self.scrollView.contentSize.height == 0.0f) {
        frame = AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size, self.scrollView.bounds);
    }
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = CGRectMake(0,0 , frame.size.width, frame.size.height);
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    } if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    self.imageView.frame = frameToCenter;
}

#pragma mark - ScrollView Methods

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
