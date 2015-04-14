//
//  KLPhotoViewer.h
//  Klike
//
//  Created by admin on 14/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLPhotoViewerDelegate <NSObject>

- (void)photoViewerDidDissmiss;

@end

@interface KLPhotoViewer : UIViewController
@property (nonatomic, weak) id<KLPhotoViewerDelegate> delegate;

- (instancetype)initWithImageFile:(PFFile *)imageFile;

@end
