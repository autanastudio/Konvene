//
//  KLPricingController.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSegmentedController.h"

@class KLEvent;

@protocol KLPricingDelegate <NSObject>

- (void)dissmissCreateEvent;

@end

@interface KLPricingController : KLSegmentedController

@property (nonatomic, strong) id<KLPricingDelegate> delegate;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
