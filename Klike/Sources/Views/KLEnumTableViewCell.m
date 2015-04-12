//
//  KLEnumTableViewCell.m
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEnumTableViewCell.h"

@implementation KLEnumTableViewCell

- (void)configureWithEnumObject:(KLEnumObject *)enumObject
{
    self.tickImageView.hidden = YES;
    if (enumObject.additionalDescriptionString) {
        self.titleLabel.text = enumObject.additionalDescriptionString;
    } else {
        self.titleLabel.text = enumObject.descriptionString;
    }
    if (enumObject.iconNameString.length>0) {
        self.iconImageView.image = [UIImage imageNamed:enumObject.iconNameString];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.tickImageView.hidden = !selected;
}

@end
