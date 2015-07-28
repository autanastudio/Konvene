//
//  KLEventHeaderView.m
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventHeaderView.h"

@interface KLEventHeaderView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation KLEventHeaderView

- (UIView *)flexibleView
{
    return self.eventImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.eventImageView.file.isDataAvailable) {
        if (!self.gradientLayer) {
            self.gradientLayer = [self grayGradient];
            self.gradientLayer.frame = self.eventImageView.frame;
            [self.eventImageView.layer addSublayer:self.gradientLayer];
        } else {
            self.gradientLayer.frame = self.eventImageView.frame;
        }
    }
}

- (void)configureWithEvent:(KLEvent *)event
{
    if (event.backImage) {
        self.eventImageView.file = event.backImage;
        [self.eventImageView loadInBackground];
    }
}

- (CAGradientLayer *)grayGradient
{
    UIColor *topColor = [UIColor colorWithWhite:0.
                                          alpha:0.5];
    UIColor *bottomColor = [UIColor clearColor];
    return [UIImage gradientLayerWithTopColor:topColor
                                  bottomColor:bottomColor];
}

- (void)startAppearAnimation
{
    _imageFake.image = self.eventImageView.image;
    _imageFake.hidden = NO;
    _imageFake.alpha = 1.0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         _imageFake.alpha = 0;
                     }];
}

@end
