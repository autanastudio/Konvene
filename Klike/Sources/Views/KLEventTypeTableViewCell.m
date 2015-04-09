//
//  KLEventTypeTableViewCell.m
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventTypeTableViewCell.h"
@interface KLEventTypeTableViewCell ()
{
    IBOutlet UILabel *_labelEventName;
    IBOutlet UIImageView *_imageEventIcon;
    IBOutlet UIView *_viewSeparator;
    IBOutlet UIImageView *_imageTick;
}

@end

@implementation KLEventTypeTableViewCell

- (void)awakeFromNib {
}

- (void)configureWithEvent:(NSString *)event imageSrc:(NSString *)imageSrc contentMode:(UIViewContentMode)mode
{
    [self configureWithEvent:event imageSrc:imageSrc];
    _imageEventIcon.contentMode = mode;
}

- (void)configureWithEvent:(NSString *)event imageSrc:(NSString *)imageSrc
{
    _labelEventName.text = event;
    _imageEventIcon.contentMode = UIViewContentModeCenter;
    if (imageSrc.length > 0)
        _imageEventIcon.image = [UIImage imageNamed:imageSrc];
    else
        _imageEventIcon.image = [UIImage new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _imageTick.hidden = NO;
    } else {
        _imageTick.hidden = YES;
    }
    // Configure the view for the selected state
}

@end
