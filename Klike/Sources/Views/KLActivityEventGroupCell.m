//
//  KLActivityEventGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityEventGroupCell.h"

@interface KLActivityEventGroupCell ()

@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *usersImages;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation KLActivityEventGroupCell

- (void)awakeFromNib
{
    for (PFImageView *imageView in self.usersImages) {
        [imageView kl_fromRectToCircle];
    }
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
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
            if (user.userImage) {
                imageView.file = user.userImage;
                [imageView loadInBackground];
            } else {
                imageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
            }
        } else {
            imageView.hidden = YES;
        }
    }
}

+ (NSString *)reuseIdentifier
{
    return @"ActivityEventGroup";
}

@end
