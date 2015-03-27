//
//  KLInviteFriendsViewController.h
//  Klike
//
//  Created by Dima on 18.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KLSectionType)
{
    KLSectionTypeSocialInvite,
    KLSectionTypeKlikeInvite,
    KLSectionTypeContactInvite
};

typedef NS_ENUM(NSInteger, KLSocialType)
{
    KLSocialTypeFacebook,
    KLSocialTypeEmail
};

@interface KLInviteFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end
