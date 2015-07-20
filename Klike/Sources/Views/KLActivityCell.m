//
//  KLActivityCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityCell.h"

@implementation KLActivityUserCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self.userImageView autoSetDimensionsToSize:CGSizeMake(32., 32.)];
        [self.userImageView kl_fromRectToCircle];
        [self.contentView addSubview:self.userImageView];
        [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

- (void)configureWithuser:(KLUserWrapper *)user
{
    if (user.userImageThumbnail) {
        self.userImageView.file = user.userImageThumbnail;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
}

@end

@implementation KLActivityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithActivity:(KLActivity *)activity
{
    self.activity = activity;
    self.timeLabel.text = [NSString stringTimeSinceDate:activity.updatedAt];
}

+ (NSString *)reuseIdentifier
{
    return @"";
}

@end
