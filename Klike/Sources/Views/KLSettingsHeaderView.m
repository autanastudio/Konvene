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
}

@end
