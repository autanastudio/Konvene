//
//  KLActivityCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityCell.h"

@implementation KLActivityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithActivity:(KLActivity *)activity
{
    self.activity = activity;
    self.timeLabel.text = [NSString stringTimeSinceDate:activity.createdAt];
}

+ (NSString *)reuseIdentifier
{
    return @"";
}

@end
