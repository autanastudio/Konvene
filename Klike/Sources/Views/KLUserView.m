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

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.backImageView.file.isDataAvailable) {
        if (!self.gradientLayer) {
            self.gradientLayer = [self grayGradient];
            self.gradientLayer.frame = self.backImageView.frame;
            [self.backImageView.layer addSublayer:self.gradientLayer];
        } else {
            self.gradientLayer.frame = self.backImageView.frame;
        }
    }
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
        self.backImageView.file = user.userBackImage;
        [self.backImageView loadInBackground];
    }
    self.userNameLabel.text = user.fullName;
    [self.userFollowersButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[user.followers count]]
                              forState:UIControlStateNormal];
    [self.userFolowingButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[user.following count]]
                             forState:UIControlStateNormal];
    
    if (user.followers.count == 0)
        [self.userFollowersButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    else
        [self.userFollowersButton setTitleColor:[UIColor colorFromHex:0x7466D9] forState:UIControlStateNormal];
    
    
    if (user.following.count == 0)
        [self.userFolowingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    else
        [self.userFolowingButton setTitleColor:[UIColor colorFromHex:0x7466D9] forState:UIControlStateNormal];
    
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
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
