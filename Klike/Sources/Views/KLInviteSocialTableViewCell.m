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
    IBOutlet UIButton *_button;
}
@end

@implementation KLInviteSocialTableViewCell

- (void) configureForInviteType:(KLSocialInviteType)inviteType
{
    self.type = inviteType;
    switch (inviteType)
    {
        case KLSocialInviteTypeFacebook:
        {
            [_button setTitle:@"Invite via Facebook" forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:@"ic_fb"] forState:UIControlStateNormal];
            UIView *headerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
            headerSeparator.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
            [self addSubview:headerSeparator];
            break;
        }
        case KLSocialInviteTypeEmail:
        {
            [_button setTitle:@"Invite via Email" forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:@"ic_email"] forState:UIControlStateNormal];
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

- (IBAction)onClicked:(id)sender {
    [self.delegate cellDidClickInvite:self];
}

@end
