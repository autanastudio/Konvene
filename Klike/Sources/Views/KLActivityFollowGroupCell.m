//
//  KLActivityFollowGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityFollowGroupCell.h"

@interface KLActivityFollowGroupCell ()
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewTrailing;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *usersImages;

@end

@implementation KLActivityFollowGroupCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
}

@end
