//
//  KLInviteCell.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteCell.h"

@implementation KLInviteCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
}

- (void)configureWithInvite:(KLInvite *)invite
{
    KLEvent *event = invite.event;
    if (event.backImage) {
        self.eventImageView.file = event.backImage;
        [self.eventImageView loadInBackground];
    } else {
        self.eventImageView.image = [UIImage imageNamed:@"event_pic_placeholder"];
    }
    self.eventTitleLabel.text = event.title;
    
    KLUserWrapper *fromUser = [[KLUserWrapper alloc] initWithUserObject:invite.from];
    KLAttributedStringPart *name = [KLAttributedStringPart partWithString:fromUser.fullName
                                                                    color:[UIColor blackColor]
                                                                     font:[UIFont helveticaNeue:SFFontStyleMedium size:12.]];
    KLAttributedStringPart *inviteText = [KLAttributedStringPart partWithString:SFLocalized(@"activity.invite.text")
                                                                          color:[UIColor colorFromHex:0xb3b3bd]
                                                                           font:[UIFont helveticaNeue:SFFontStyleRegular size:12.]];
    self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[name, inviteText]];
    if (fromUser.userImage) {
        self.userImageView.file = fromUser.userImage;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
    
    self.timeLabel.text = [NSString stringTimeSinceDate:invite.createdAt];
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

@end
