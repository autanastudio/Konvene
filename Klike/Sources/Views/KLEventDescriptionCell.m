//
//  KLEventDescriptionCell.m
//  Klike
//
//  Created by admin on 04/05/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventDescriptionCell.h"

@implementation KLEventDescriptionCell

- (void)awakeFromNib
{
    [self.userImage kl_fromRectToCircle];
}

- (void)configureWithEvent:(KLEvent *)event
{
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:event.owner];
    if (user.userImage) {
        self.userImage.file = user.userImage;
        [self.userImage loadInBackground];
    }
    self.userName.text = user.fullName;
    if ([event.descriptionText notEmpty]) {
        [self.descriptionLabel setText:event.descriptionText
                 withMinimumLineHeight:20
                         strikethrough:NO];
    } else {
        self.descriptionLabel.text = @"";
    }
    [self layoutIfNeeded];
}

@end
