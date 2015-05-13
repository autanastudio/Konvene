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
    
    _constraintViewInactiveExternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewInactiveInternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [_viewInactive layoutIfNeeded];
    
    _constraintViewActiveExternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewActiveInternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [_viewActive layoutIfNeeded];
    
    [self setRating:0.5 animated:NO];
}

- (void)setRating:(float)rating animated:(BOOL)animated
{
    float screenW = [UIScreen mainScreen].bounds.size.width;
    float inactiveExternalX = 0;
    float inactiveExternalW = 0;
    float inactiveInternalX = 0;
    
    float activeExternalW = 0;
    
    float bound = (screenW / 5 - 40) / 2 - 1;
    float totalActiveWidth = screenW - bound * 2.0;
    activeExternalW = totalActiveWidth * rating + bound + 2 * rating;
    
    _constraintViewActiveExternalWidth.constant = activeExternalW;
    [_viewActive layoutIfNeeded];
    
    inactiveExternalX = activeExternalW;
    inactiveExternalW = screenW - inactiveExternalX;
    inactiveInternalX = - inactiveExternalX;
    _constraintViewInactiveInternalX.constant = inactiveInternalX;
    _constraintViewInactiveExternalWidth.constant = inactiveExternalW;
    _constraintViewInactiveExternalX.constant = inactiveExternalX;
    [_viewInactive layoutIfNeeded];
    
}

@end
