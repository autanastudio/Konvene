//
//  InviteSocialTableViewCell.h
//  Klike
//
//  Created by Dima on 20.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLInviteSocialTableViewCell;

typedef NS_ENUM(NSInteger, KLSocialInviteType)
{
    KLSocialInviteTypeFacebook,
    KLSocialInviteTypeEmail
};

@protocol KLInviteSocialTableViewCellDelegate <NSObject>

- (void) cellDidClickInvite:(KLInviteSocialTableViewCell *)cell;

@end

@interface KLInviteSocialTableViewCell : UITableViewCell

@property (nonatomic, weak) id <KLInviteSocialTableViewCellDelegate> delegate;
@property KLSocialInviteType type;

- (void) configureForInviteType:(KLSocialInviteType)inviteType;

@end
