//
//  KLSettingsHeaderView.m
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSettingsHeaderView.h"

@implementation KLSettingsHeaderView

- (UIView *)flexibleView
{
    return self.backImageView;
}

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
    [self.userPhotoButton kl_fromRectToCircle];
    self.userPhotoButton.backgroundColor = [UIColor colorWithWhite:0
                                                             alpha:.6];
}

- (void)updateWithUser:(KLUserWrapper *)user
{
    if (user.userImageThumbnail) {
        self.userImageView.file = user.userImageThumbnail;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
    if (user.userBackImage) {
        self.backShadowView.hidden = NO;
        self.backImageView.file = user.userBackImage;
        [self.backImageView loadInBackground];
    }
}

@end
