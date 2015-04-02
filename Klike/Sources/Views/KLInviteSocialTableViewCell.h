//
//  InviteSocialTableViewCell.h
//  Klike
//
//  Created by Dima on 20.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KLSocialInviteType)
{
    KLSocialInviteTypeFacebook,
    KLSocialInviteTypeEmail
};

@interface KLInviteSocialTableViewCell : UITableViewCell
- (void) configureForInviteType:(KLSocialInviteType)inviteType;
@end
