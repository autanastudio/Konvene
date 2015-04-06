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
}

@end@implementation KLEventTypeTableViewCell

- (void)awakeFromNib {
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
}

- (void)configureWithEvent:(NSString *)event imageSrc:(NSString *)imageSrc
{
    _labelEventName.text = event;
    if (imageSrc.length > 0)
        _imageEventIcon.image = [UIImage imageNamed:imageSrc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
