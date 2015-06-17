//
//  KLUserProfileView.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserProfileView.h"

@implementation KLUserProfileView

- (void)updateWithUser:(KLUserWrapper *)user
{
    [super updateWithUser:user];
    self.isFollowed = [[KLAccountManager sharedManager] isFollowing:user];
    [self updateFollowStatus];
}

- (void)updateFollowStatus
{
    if (self.isFollowed) {
        [self.followButton setImage:[UIImage imageNamed:@"ic_following"]
                           forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_big_filled"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.following.button")
                           forState:UIControlStateNormal];
    } else {
        [self.followButton setImage:nil
                           forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_big_stroke"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.follow.button")
                           forState:UIControlStateNormal];
    }
}

@end
