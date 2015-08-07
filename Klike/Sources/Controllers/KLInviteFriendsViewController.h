//
//  KLInviteFriendsViewController.h
//  Klike
//
//  Created by Dima on 18.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KLInviteType)
{
    KLInviteTypeFriends,
    KLInviteTypeEvent
};


typedef NS_ENUM(NSInteger, KLSectionType)
{
    KLSectionTypeSocialInvite,
    KLSectionTypeFollowersInvite,
    KLSectionTypeKlikeInvite,
    KLSectionTypeContactInvite,
};

typedef NS_ENUM(NSInteger, KLSocialType)
{
    KLSocialTypeFacebook,
    KLSocialTypeEmail
};

@interface KLInviteFriendsViewController : KLViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_followers;
    PFQuery *_queryFollowers;
    BOOL _extendFirstRow;
    NSLayoutConstraint *_constraintScrollX;
}

@property KLInviteType inviteType;
@property BOOL isEventJustCreated;
@property BOOL isAfterSignIn;
@property BOOL needBackButton;
@property KLEvent *event;

- (instancetype) initForType:(KLInviteType)type;

@end
