//
//  QDRefreshControl.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 22/09/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLActivityIndicator;

typedef NS_ENUM(NSUInteger, SFRefreshControlAligment) {
    SFRefreshControlAlignmentTop,
    SFRefreshControlAlignmentBottom,
};
/**
 *  Refresh control to use as drop replacement of UIRefreshControl
 */
@interface SFRefreshControl : UIControl
@property (nonatomic, strong) KLActivityIndicator *activityIndicator;
@property(nonatomic, assign) SFRefreshControlAligment alignment;
@property(nonatomic, assign) BOOL shouldAdjustForPinnedHeader;

- (void)didRelease;
- (void)endUpdating;

@end
