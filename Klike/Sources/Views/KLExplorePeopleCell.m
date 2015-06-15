//
//  KLExplorePeopleCell.m
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleCell.h"

@interface KLExplorePeopleCell ()

@end

@implementation KLExplorePeopleCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
    [self.followButton addTarget:self
                          action:@selector(onFollow)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureWithUser:(KLUserWrapper *)user
{
    self.user = user;
    self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    self.userImageView.file = user.userImageThumbnail;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
    
    UIColor *grayCountColor = [UIColor colorFromHex:0xB3B3BD];
    UIFont *countFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    NSString *folloewrsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.followers.count];
    
    KLAttributedStringPart *counterFollowers = [[KLAttributedStringPart alloc] initWithString:folloewrsCountString
                                                                               color:[UIColor blackColor]
                                                                                font:countFont];
    KLAttributedStringPart *descriptionFollowers = [[KLAttributedStringPart alloc] initWithString:SFLocalized(@"userlist.followers.count")
                                                                                   color:grayCountColor
                                                                                    font:countFont];
    self.followersCountLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[counterFollowers, descriptionFollowers]];
    
    NSString *eventsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.createdEvents.count];
    KLAttributedStringPart *counterEvents= [[KLAttributedStringPart alloc] initWithString:eventsCountString
                                                                                        color:[UIColor blackColor]
                                                                                         font:countFont];
    KLAttributedStringPart *descriptionEvents = [[KLAttributedStringPart alloc] initWithString:SFLocalized(@"userlist.events.count")
                                                                                            color:grayCountColor
                                                                                             font:countFont];
    self.eventsCountLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[counterEvents, descriptionEvents]];
    
    if ([[KLAccountManager sharedManager] isFollowing:user]) {
        [self.followButton setImage:[UIImage imageNamed:@"ic_following"]
                           forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_small_filled"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.following.button")
                           forState:UIControlStateNormal];
    } else {
        [self.followButton setImage:nil
                           forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_small_stroke"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.follow.button")
                           forState:UIControlStateNormal];
    }
}

- (void)onFollow
{
    self.followButton.enabled = NO;
    BOOL follow = ![[KLAccountManager sharedManager] isFollowing:self.user];
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] follow:follow
                                        user:self.user
                            withCompletition:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    [weakSelf configureWithUser:weakSelf.user];
                                    weakSelf.followButton.enabled = YES;
                                }
                            }];
}

@end
