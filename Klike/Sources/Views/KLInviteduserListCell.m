//
//  KLInviteduserListCell.m
//  Klike
//
//  Created by Alexey on 7/24/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteduserListCell.h"

@interface KLInviteduserListCell ()

@property (nonatomic, strong) KLInvite *invite;
@property (nonatomic, assign) BOOL isInvited;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;


@end

@implementation KLInviteduserListCell

@synthesize activeButton = _followButton;

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
    [self.activeButton addTarget:self
                          action:@selector(onActive)
                forControlEvents:UIControlEventTouchUpInside];
    [self.activeButton setBackgroundImage:[UIImage imageNamed:@"btn_disabled_private"]
                                 forState:UIControlStateDisabled];
    [self.activeButton setImage:nil
                       forState:UIControlStateDisabled];
    [self.activeButton setTitle:SFLocalized(@"Invited")
                       forState:UIControlStateDisabled];
    [self.activeButton setTitleColor:[UIColor colorFromHex:0xb3b3bd]
                            forState:UIControlStateNormal];
}

- (void)configureWithInvite:(KLInvite *)invite
{
    self.invite = invite;
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:invite.to];
    
    self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    self.userImageView.file = user.userImageThumbnail;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
    
    self.isInvited = YES;
    
    BOOL isOwner = [[KLAccountManager sharedManager].currentUser.userObject.objectId isEqualToString:self.invite.event.owner.objectId];
    
    if (isOwner || [invite.from.objectId isEqualToString:[KLAccountManager sharedManager].currentUser.userObject.objectId]) {
        self.activeButton.enabled = YES;
        [self updateStatus];
    } else {
        self.activeButton.enabled = NO;
    }
}

- (void)updateStatus
{
    if (self.isInvited) {
        [self.activeButton setImage:[UIImage imageNamed:@"ic_following"]
                           forState:UIControlStateNormal];
        [self.activeButton setBackgroundImage:[UIImage imageNamed:@"btn_small_filled"]
                                     forState:UIControlStateNormal];
        [self.activeButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [self.activeButton setTitle:SFLocalized(@"Invited")
                           forState:UIControlStateNormal];
    } else {
        [self.activeButton setImage:nil
                           forState:UIControlStateNormal];
        [self.activeButton setBackgroundImage:[UIImage imageNamed:@"btn_small_stroke"]
                                     forState:UIControlStateNormal];
        [self.activeButton setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [self.activeButton setTitle:SFLocalized(@"Invite")
                           forState:UIControlStateNormal];
    }
}

- (void)onActive
{
    BOOL active = !self.isInvited;
    self.isInvited = active;
    [self updateStatus];
    
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:self.invite.to];
    
    [[KLEventManager sharedManager] inviteUser:user
                                       toEvent:self.invite.event
                                      isInvite:active
                                  completition:^(id object, NSError *error) {
                                      self.invite.event = object;
                                  }];
}

@end
