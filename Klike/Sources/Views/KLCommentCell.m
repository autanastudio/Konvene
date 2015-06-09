//
//  KLCommentCell.m
//  Klike
//
//  Created by Alexey on 5/18/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCommentCell.h"

@interface KLCommentCell ()

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation KLCommentCell

- (void)awakeFromNib
{
    [self.userImage kl_fromRectToCircle];
}

- (void)configureWithComment:(KLEventComment *)comment
                     isOwner:(BOOL)isOwner
{
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:comment.owner];
    if (user.userImageThumbnail) {
        self.userImage.file = user.userImageThumbnail;
        [self.userImage loadInBackground];
    } else {
        self.userImage.image = [UIImage imageNamed:@"profile_pic_chat_placeholder"];
    }
    if (!isOwner && self.userNameLabel) {
        self.userNameLabel.text = user.fullName;
    }
    [self.commentTextLabel setText:comment.text
             withMinimumLineHeight:20
                     strikethrough:NO];
    self.timeLabel.text = [NSString stringTimeSinceDate:comment.createdAt];
    [self layoutIfNeeded];
}

@end
