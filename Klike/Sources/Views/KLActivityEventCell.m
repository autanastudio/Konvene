//
//  KLActivityEventCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityEventCell.h"

@interface KLActivityEventCell ()
@property (weak, nonatomic) IBOutlet PFImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation KLActivityEventCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
}

@end
