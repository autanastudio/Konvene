//
//  KLPhotoViewer.h
//  Klike
//
//  Created by admin on 14/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPhotoViewerAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UISwipeGestureRecognizerDirection dismissDirection;
@end

@protocol KLPhotoViewerDelegate <NSObject>

- (void)photoViewerDidDissmiss;

@end

@interface KLPhotoViewer : UIViewController
@property (nonatomic, weak) id<KLPhotoViewerDelegate> delegate;
@property (nonatomic, assign) UISwipeGestureRecognizerDirection dismissDirection;

- (instancetype)initWithImageFile:(PFFile *)imageFile;

@end
