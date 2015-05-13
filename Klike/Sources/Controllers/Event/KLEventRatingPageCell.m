//
//  KLEventRatingPageCell.m
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventRatingPageCell.h"

@implementation KLEventRatingPageCell

- (void)awakeFromNib
{
    _constraintViewActiveTotalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewActiveWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [_viewActive layoutIfNeeded];
}

- (void)setRating:(float)rating animated:(BOOL)animated
{}

@end
