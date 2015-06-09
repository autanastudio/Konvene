//
//  KLActivityFollowGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityFollowGroupCell.h"

static CGFloat klUserImageWidth = 24.;
static CGFloat klUserImageTraling = 8.;

@interface KLActivityFollowGroupCell ()
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewTrailing;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *usersImages;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation KLActivityFollowGroupCell

- (void)awakeFromNib
{
    for (PFImageView *imageView in self.usersImages) {
        [imageView kl_fromRectToCircle];
    }
    [self.userImageView kl_fromRectToCircle];
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
    UIFont *descriptionFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    UIColor *grayColor = [UIColor colorFromHex:0xb3b3bd];
    UIColor *purpleColor = [UIColor colorFromHex:0x6466ca];
    
    if ([self.activity.activityType integerValue] == KLActivityTypeFollowMe) {
        NSString *descritpionStr = [NSString stringWithFormat:@"%lu users started following you", (unsigned long)self.activity.users.count];
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:descritpionStr
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[description]];
        
        self.userImageViewWith.constant = 0;
        self.userImageViewTrailing.constant = 0;
        
    } else if([self.activity.activityType integerValue] == KLActivityTypeFollow){
        KLUserWrapper *from  = [[KLUserWrapper alloc] initWithUserObject:self.activity.from];
        if (from.userImageThumbnail) {
            self.userImageView.file = from.userImageThumbnail;
            [self.userImageView loadInBackground];
        } else {
            self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
        }
        KLAttributedStringPart *fromStr = [[KLAttributedStringPart alloc] initWithString:from.fullName
                                                                                   color:purpleColor
                                                                                    font:descriptionFont];
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:@" started following "
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[fromStr, description]];
        
        self.userImageViewWith.constant = klUserImageWidth;
        self.userImageViewTrailing.constant = klUserImageTraling;
    }
    
    NSInteger limit = MIN(activity.users.count, 5);
    if (limit<5) {
        self.countLabel.hidden = YES;
    } else {
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:SFLocalized(@"acitivity.people"), activity.users.count];
    }
    for (PFImageView *imageView in self.usersImages) {
        if (imageView.tag<limit) {
            imageView.hidden = NO;
            KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:activity.users[imageView.tag]];
            if (user.userImageThumbnail) {
                imageView.file = user.userImageThumbnail;
                [imageView loadInBackground];
            } else {
                imageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
            }
        } else {
            imageView.hidden = YES;
        }
    }
    [self layoutIfNeeded];
}


+ (NSString *)reuseIdentifier
{
    return @"ActivityFollowGroup";
}

@end
