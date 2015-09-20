//
//  KLVenmoInfoController.h
//  Klike
//
//  Created by Nick O'Neill on 9/20/15.
//  Copyright © 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"
#import "KLPricingController.h"

@interface KLVenmoInfoController : KLViewController

@property (nonatomic, weak) id<KLPricingDelegate> delegate;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
