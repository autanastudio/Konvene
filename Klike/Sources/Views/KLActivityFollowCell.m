//
//  KLActivityFollowCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityFollowCell.h"

@interface KLActivityFollowCell ()
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation KLActivityFollowCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
    KLUserWrapper *from = [[KLUserWrapper alloc] initWithUserObject:self.activity.from];
    if (from.userImage) {
        self.userImageView.file = from.userImage;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
    
    UIFont *descriptionFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    UIColor *grayColor = [UIColor colorFromHex:0xb3b3bd];
    UIColor *purpleColor = [UIColor colorFromHex:0x6466ca];
    KLAttributedStringPart *fromStr = [[KLAttributedStringPart alloc] initWithString:from.fullName
                                                                               color:purpleColor
                                                                                font:descriptionFont];
    if ([self.activity.activityType integerValue] == KLActivityTypeFollowMe) {
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:@" started following you"
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[fromStr, description]];
    } else if([self.activity.activityType integerValue] == KLActivityTypeFollow){
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:@" started following "
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        KLUserWrapper *to = [[KLUserWrapper alloc] initWithUserObject:activity.users[0]];
        KLAttributedStringPart *toStr = [[KLAttributedStringPart alloc] initWithString:to.fullName
                                                                                 color:purpleColor
                                                                                  font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[fromStr, description, toStr]];
    }
    
}

@end
