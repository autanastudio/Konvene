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
    IBOutlet UIView *_viewSeparator;
    IBOutlet UIImageView *_imageIcon;
    IBOutlet UILabel *_labelSocial;
}
@end

@implementation KLInviteSocialTableViewCell

- (void) configureForInviteType:(KLInviteType)inviteType
{
    switch (inviteType)
    {
        case KLInviteTypeFacebook:
        {
            [_labelSocial setText:@"Invite via Facebook"];
            [_imageIcon setImage:[UIImage imageNamed:@"ic_fb"]];
            UIView *headerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
            headerSeparator.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
            [self addSubview:headerSeparator];
            break;
        }
        case KLInviteTypeEmail:
        {
            [_labelSocial setText:@"Invite via Email"];
            [_imageIcon setImage:[UIImage imageNamed:@"ic_email"]];
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
