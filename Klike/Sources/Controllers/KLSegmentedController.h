//
//  KLSegmentedController.h
//  Klike
//
//  Created by admin on 09/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSegmentedControl;

@interface KLSegmentedController : UIViewController

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

- (id)initWithChildControllers:(NSArray *)controllers;
- (void)updateSegmentedControlTitles;

@end
