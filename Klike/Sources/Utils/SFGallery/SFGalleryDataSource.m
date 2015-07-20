//
//  SFGalleryDataSource.m
//  Livid
//
//  Created by Sibagatov Ildar on 23.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryDataSource.h"
#import "SFGalleryPage.h"


@implementation SFGalleryDataSource

- (void)loadContentIfNeeded:(BOOL)forced
{
    if (self.items.count == 0 || forced) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadContent) object:nil];
        [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.1];
    } else {
        [self notifyDidLoadContentWithError:nil];
    }
}

- (void)loadContent
{
    //Nothing here
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if ([self.delegate respondsToSelector:@selector(dataSource:didLoadContentWithError:)]) {
        [self.delegate dataSource:self didLoadContentWithError:nil];
    }
}

- (id)itemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.items.count) {
        return nil;
    }
    return self.items[index];
}

- (SFGalleryPage *)pageForIndex:(NSUInteger)index
{
    SFGalleryPage *page = [[SFGalleryPage alloc] initWithMedia:[self itemAtIndex:index] atPage:index];
    page.delegate = (id<SFGalleryPageDelegate>)self.delegate;
    return page;
}

- (void)notifyDidLoadContentWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(dataSource:didLoadContentWithError:)]) {
        [self.delegate dataSource:self didLoadContentWithError:error];
    }
}

#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    SFGalleryPage *galleryPage = (SFGalleryPage *)viewController;
    NSInteger index = galleryPage.index;
    if (index == 0) {
        return nil;
    }
    index--;
    return [self pageForIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    SFGalleryPage *galleryPage = (SFGalleryPage *)viewController;
    NSInteger index = galleryPage.index;
    if (index == self.items.count - 1) {
        return nil;
    }
    index++;
    return [self pageForIndex:index];
}

#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    SFGalleryPage *galleryPage = pageViewController.viewControllers.firstObject;
    self.pageIndex = galleryPage.index;
    if ([self.delegate respondsToSelector:@selector(dataSource:didFinishedAnimation:)]) {
        [self.delegate dataSource:self didFinishedAnimation:previousViewControllers];
    }
}

@end
