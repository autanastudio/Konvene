//
//  KLUserView.m
//  Klike
//
//  Created by admin on 26/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserView.h"
#import "KLUserWrapper.h"

@interface KLUserView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation KLUserView

- (UIView *)flexibleView
{
    return self.backImageView;
}

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
}

- (void)updateWithUser:(KLUserWrapper *)user
{
    if (user.userImage) {
        self.userImageView.file = user.userImage;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
    if (user.userBackImage) {
        if (!self.gradientLayer) {
            self.gradientLayer = [self grayGradient];
            self.gradientLayer.frame = self.backImageView.frame;
            [self.backImageView.layer addSublayer:self.gradientLayer];
        }
        self.backImageView.file = user.userBackImage;
        [self.backImageView loadInBackground];
    }
    self.userNameLabel.text = user.fullName;
    [self.userFollowersButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[user.followers count]]
                              forState:UIControlStateNormal];
    [self.userFolowingButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[user.following count]]
                             forState:UIControlStateNormal];
}

- (CAGradientLayer *)grayGradient
{
    UIColor *topColor = [UIColor colorWithWhite:0.
                                          alpha:0.5];
    UIColor *bottomColor = [UIColor clearColor];
    return [UIImage gradientLayerWithTopColor:topColor
                                  bottomColor:bottomColor];
}

@end
