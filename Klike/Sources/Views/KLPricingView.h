//
//  KLPricingView.h
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPricingView : UIView

@property (nonatomic, strong) KLEventPrice *price;

- (instancetype)initWithEventPrice:(KLEventPrice *)eventPrice;
- (void)configureWithPrice:(KLEventPrice *)price;

@end
