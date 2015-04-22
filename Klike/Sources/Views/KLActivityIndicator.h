//
//  KLActivityIndicator.h
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLActivityIndicator : UIView
@property(nonatomic, assign) BOOL animating;
@property(nonatomic, readonly) NSInteger stepCount;

+ (KLActivityIndicator *)whiteIndicator;
+ (KLActivityIndicator *)colorIndicator;

- (instancetype)initWithImages:(NSArray *)images;
- (void)stepAnimation;

@end
