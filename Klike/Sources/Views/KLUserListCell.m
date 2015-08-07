//
//  KLUserListCell.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserListCell.h"
#import "AppDelegate.h"

@interface KLUserListCell ()

@property (nonatomic, strong) KLUserWrapper *user;
@property (nonatomic, assign) BOOL isFollowed;

@end

@implementation KLUserListCell

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
    
    if ([[KLAccountManager sharedManager].currentUser isEqualToUser:self.user]) {
        self.followButton.hidden = YES;
    } else {
        self.followButton.hidden = NO;
    }
    
    self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    self.userImageView.file = user.userImageThumbnail;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
    
    self.isFollowed = [[KLAccountManager sharedManager] isFollowing:user];
    [self updateFollowStatus];
}

- (void)updateFollowStatus
{
    if (self.isFollowed) {
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
    BOOL follow = !self.isFollowed;
    void (^followBlock)() = ^void(){
        self.isFollowed = follow;
        [self updateFollowStatus];
        
        [[KLAccountManager sharedManager] follow:follow
                                            user:self.user
                                withCompletition:^(BOOL succeeded, NSError *error) {
                                    
                                }];
    };
    if (follow) {
        followBlock();
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Unfollow %@?", self.user.fullName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* unfollowAction = [UIAlertAction actionWithTitle:@"Unfollow"
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * action) {
                                                                   followBlock();
                                                               }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:unfollowAction];
        [alert addAction:cancelAction];
        [[ADI currentNavigationController] presentViewController:alert animated:YES completion:^{
        }];
    }
}

@end
