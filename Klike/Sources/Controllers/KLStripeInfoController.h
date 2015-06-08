//
//  KLStripeInfoController.h
//  Klike
//
//  Created by Alexey on 6/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"
#import "KLPricingController.h"

@interface KLStripeInfoController : KLViewController

@property (nonatomic, weak) id<KLPricingDelegate> delegate;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
