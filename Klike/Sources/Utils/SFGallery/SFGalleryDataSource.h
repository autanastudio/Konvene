//
//  SFGalleryDataSource.h
//  Livid
//
//  Created by Sibagatov Ildar on 23.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFGalleryPage;
@class SFGalleryDataSource;

@protocol SFGalleryDataSourceDelegate <NSObject>
@optional
- (void)dataSource:(SFGalleryDataSource *)dataSource didLoadContentWithError:(NSError *)error;
- (void)dataSource:(SFGalleryDataSource *)dataSource didFinishedAnimation:(NSArray*)previousViewControllers;
@end

@interface SFGalleryDataSource : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, weak) id<SFGalleryDataSourceDelegate> delegate;

- (SFGalleryPage *)pageForIndex:(NSUInteger)index;

- (id)itemAtIndex:(NSInteger)index;

- (void)loadContentIfNeeded:(BOOL)forced;
- (void)loadContent;

@end
