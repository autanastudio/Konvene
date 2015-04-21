//
//  KLSegmentedController.h
//  Klike
//
//  Created by admin on 09/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSegmentedControl;

@interface KLSegmentedController : KLViewController

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *childControllers;

- (id)initWithChildControllers:(NSArray *)controllers;
- (void)updateSegmentedControlTitles;

@end
