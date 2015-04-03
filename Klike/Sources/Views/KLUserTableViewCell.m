//
//  KLUserTableViewCell.m
//  Klike
//
//  Created by Дмитрий Александров on 01.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserTableViewCell.h"
@interface KLUserTableViewCell ()
{
    IBOutlet PFImageView *_imagePhoto;
    IBOutlet UILabel *_labelUserInitials;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UIButton *_buttonFollow;
    
}
@end

@implementation KLUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureWithUser:(KLUserWrapper *)user {
    self.user = user;
    _labelUserName.text = user.fullName;
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [user.fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    _labelUserInitials.text = firstCharacters;
    if (user.userImage) {
        _imagePhoto.file = user.userImage;
        [_imagePhoto loadInBackground];
    } else {
        _imagePhoto.image = [UIImage new];
    }
    [self styleFollowButton];
    [self update];
}

- (void)styleFollowButton
{
    _buttonFollow.layer.cornerRadius = 12;
    _buttonFollow.layer.borderWidth = 2;
    _buttonFollow.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
}

- (IBAction)onFollowClicked:(id)sender {
    [self.delegate cellDidClickFollow:self];
}

- (void)update
{
    if ([[KLAccountManager sharedManager] isFollowing:self.user]) {
        _buttonFollow.backgroundColor = [UIColor colorFromHex:0x6466ca];
        [_buttonFollow setTitle:@"Followed" forState:UIControlStateNormal];
        [_buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        _buttonFollow.backgroundColor = [UIColor colorFromHex:0xffffff];
        [_buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [_buttonFollow setTitleColor:[UIColor colorFromHex:0x888AF0] forState:UIControlStateNormal];    }
}

@end
