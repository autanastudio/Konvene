//
//  KLExplorePeopleCell.m
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleCell.h"

@interface KLExplorePeopleCell ()

@property (nonatomic, strong) KLUserWrapper *user;

@end

@implementation KLExplorePeopleCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
}

- (void)configureWithUser:(KLUserWrapper *)user
{
    self.user = user;
    self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    self.userImageView.file = user.userImage;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
}

@end
