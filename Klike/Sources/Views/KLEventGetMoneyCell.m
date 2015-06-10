//
//  KLEventGetMoneyCell.m
//  Klike
//
//  Created by Alexey on 6/10/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGetMoneyCell.h"

@interface KLEventGetMoneyCell ()


@property (weak, nonatomic) IBOutlet UIView *coloredView;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyButton;

@end

@implementation KLEventGetMoneyCell

- (void)configureWithEvent:(KLEvent *)event
{
    UIColor *payedColor = [UIColor colorFromHex:0x346bbd];
    UIColor *throwInColor = [UIColor colorFromHex:0x0494b3];
    [super configureWithEvent:event];
    if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
        self.coloredView.backgroundColor = payedColor;
    } else {
        self.coloredView.backgroundColor = throwInColor;
    }
}

@end
