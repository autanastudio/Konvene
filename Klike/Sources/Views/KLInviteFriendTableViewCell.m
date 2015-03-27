//
//  InviteFriendTableViewCell.m
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteFriendTableViewCell.h"
static NSString *klUserKeyPk = @"userPk";
static NSString *klUserKeyBackImage = @"userBackImage";
static NSString *klUserKeyisRegistered = @"isRegistered";
static NSString *klUserKeyFullName = @"fullName";
static NSString *klUserKeyFirstName = @"firstName";
static NSString *klUserKeyLastName = @"lastName";
static NSString *klUserKeyEmails = @"emails";
static NSString *klUserKeyPhone = @"phone";

@implementation KLInviteFriendTableViewCell
{
    IBOutlet UIImageView *_imageUserPhoto;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UILabel *_labelUserInitials;
    IBOutlet UIButton *_buttonInvite;
    IBOutlet UIButton *_buttonSendEmail;
    IBOutlet UIButton *_buttonSendSMS;
    
}

- (void) configureWithUser:(PFUser *)user
{
    self.user = user;
    _labelUserName.text = user[klUserKeyFullName];
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [user[@"fullName"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    _labelUserInitials.text = [firstCharacters substringToIndex:MIN(2, words.count)];
    [self styleButtons];
}

- (void)styleButtons {
    _buttonInvite.layer.cornerRadius = 12;
    _buttonInvite.layer.borderWidth = 2;
    _buttonInvite.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    _buttonSendEmail.layer.cornerRadius = 12;
    _buttonSendEmail.layer.borderWidth = 2;
    _buttonSendEmail.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    _buttonSendSMS.layer.cornerRadius = 12;
    _buttonSendSMS.layer.borderWidth = 2;
    _buttonSendSMS.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    if (_registered)
    {
        _buttonInvite.hidden = NO;
        _buttonSendSMS.hidden = YES;
        _buttonSendEmail.hidden = YES;
    }
    else
    {
        _buttonInvite.hidden = YES;
        _buttonSendSMS.hidden = NO;
        _buttonSendEmail.hidden = NO;
    }

}

- (IBAction)onAddUser:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClickAddUser:)])
    {
        [self.delegate cellDidClickAddUser:self];
    }
}

- (IBAction)onMailUser:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClickSendMail:)]){
        [self.delegate cellDidClickSendMail:self];
    }
}

- (IBAction)onSmsUser:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClickSendSms:)]){
        [self.delegate cellDidClickSendSms:self];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
