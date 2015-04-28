//
//  KLSegmentedControl.h
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLSegmentedControl : UISegmentedControl

@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, strong) UIColor *indicatorColor;

+ (KLSegmentedControl *)kl_segmentedControl;
- (void)setContentOffset:(CGSize)offset;

@end
