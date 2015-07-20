//
//  KLStatHeaderView.h
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"

@interface KLStatHeaderView : UIView

- (void)configureWithEvnet:(KLEvent *)event;
- (void)startAnimation;

@end
