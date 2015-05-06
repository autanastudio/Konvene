//
//  KLExplorePeopleCell.m
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleCell.h"

@interface KLExplorePeopleCell ()

@property (nonatomic, strong) KLUserWrapper *user;

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
    self.userImageView.file = user.userImage;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
    
    UIColor *grayCountColor = [UIColor colorFromHex:0xB3B3BD];
    UIFont *countFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    NSString *folloewrsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.followers.count];
    NSDictionary *colorMapFollowers = @{ folloewrsCountString : grayCountColor,
                                         SFLocalized(@"userlist.followers.count") : [UIColor blackColor]};
    self.followersCountLabel.attributedText = [self coloredStringWithDictionary:colorMapFollowers font:countFont];
    
    NSString *eventsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.createdEvents.count];
    NSDictionary *colorMapEvents = @{ eventsCountString : grayCountColor,
                                      SFLocalized(@"userlist.events.count") : [UIColor blackColor]};
    self.eventsCountLabel.attributedText = [self coloredStringWithDictionary:colorMapEvents font:countFont];
    
    if ([[KLAccountManager sharedManager] isFollowing:user]) {
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_small_filled"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.following.button")
                           forState:UIControlStateNormal];
    } else {
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"btn_small_stroke"]
                                     forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [self.followButton setTitle:SFLocalized(@"userlist.follow.button")
                           forState:UIControlStateNormal];
    }
}

- (NSMutableAttributedString *)coloredStringWithDictionary:(NSDictionary *)colorMappingDict
                                                      font:(UIFont *)font
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSString * word in colorMappingDict) {
        UIColor * color = [colorMappingDict objectForKey:word];
        NSDictionary * attributes = @{ color : NSForegroundColorAttributeName,
                                       font : NSFontAttributeName};
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
        [string appendAttributedString:subString];
    }
    return string;
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
