//
//  InviteSocialTableViewCell.m
//  Klike
//
//  Created by Dima on 20.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteSocialTableViewCell.h"
@interface KLInviteSocialTableViewCell()
{
    IBOutlet UIButton *_buttonInvite;
    IBOutlet UIView *_viewSeparator;
}
@end

@implementation KLInviteSocialTableViewCell

- (void) configureForInviteType:(KLInviteType)inviteType
{
    switch (inviteType)
    {
        case KLInviteTypeFacebook:
        {
            _buttonInvite.titleLabel.text = @"Invite via Facebook";
            [_buttonInvite.imageView setImage:[UIImage imageNamed:@"ic_fb"]];
            break;
        }
        case KLInviteTypeEmail:
        {
             _buttonInvite.titleLabel.text = @"Invite via Email";
            [_buttonInvite.imageView setImage:[UIImage imageNamed:@"ic_email"]];
            _viewSeparator.hidden = YES;
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
