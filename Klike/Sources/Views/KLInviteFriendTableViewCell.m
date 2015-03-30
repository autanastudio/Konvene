//
//  InviteFriendTableViewCell.m
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteFriendTableViewCell.h"
#import <APAddressBook/APContact.h>


@implementation KLInviteFriendTableViewCell
{
    IBOutlet UIImageView *_imageUserPhoto;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UILabel *_labelUserInitials;
    IBOutlet UIButton *_buttonInvite;
    IBOutlet UIButton *_buttonSendEmail;
    IBOutlet UIButton *_buttonSendSMS;
    
    IBOutlet NSLayoutConstraint *_buttonsHorizontalSpacing;
    IBOutlet NSLayoutConstraint *_buttonEmailWidth;
}

- (void)configureWithContact:(APContact *)contact
{
    self.contact = contact;
    _labelUserName.text = [self contactName:self.contact];
    NSString *firstChar = self.contact.firstName.length > 0 ? [self.contact.firstName substringToIndex:1] : @"";
    NSString *secondChar = self.contact.lastName.length > 0 ? [self.contact.lastName substringToIndex:1] : @"";
    NSString *firstCharacters = [firstChar stringByAppendingString:secondChar];
    _labelUserInitials.text = firstCharacters;
    [self styleButtons];
}

- (void)configureWithUser:(KLUserWrapper *)user
{
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
    [self styleButtons];
}
- (void)styleButtons
{
    _buttonsHorizontalSpacing.constant = 8;
    _buttonEmailWidth.constant = 56;
    _buttonInvite.layer.cornerRadius = 12;
    _buttonInvite.layer.borderWidth = 2;
    _buttonInvite.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    _buttonSendEmail.layer.cornerRadius = 12;
    _buttonSendEmail.layer.borderWidth = 2;
    _buttonSendEmail.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    _buttonSendSMS.layer.cornerRadius = 12;
    _buttonSendSMS.layer.borderWidth = 2;
    _buttonSendSMS.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    if (_registered) {
        _buttonInvite.hidden = NO;
        _buttonSendSMS.hidden = YES;
        _buttonSendEmail.hidden = YES;
    } else {
        _buttonInvite.hidden = YES;
        _buttonSendSMS.hidden = NO;
        _buttonSendEmail.hidden = NO;
    }
    if (self.contact){
        if (self.contact.phones.count == 0)
            _buttonSendSMS.hidden = YES;
        if (self.contact.emails.count == 0) {
            _buttonEmailWidth.constant = 0;
            _buttonsHorizontalSpacing.constant = 0;
        }
    }
}

- (IBAction)onAddUser:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cellDidClickAddUser:)]) {
        [self.delegate cellDidClickAddUser:self];
    }
}

- (IBAction)onMailUser:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cellDidClickSendMail:)]){
        [self.delegate cellDidClickSendMail:self];
    }
}

- (IBAction)onSmsUser:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cellDidClickSendSms:)]){
        [self.delegate cellDidClickSendSms:self];
    }
}

#pragma mark - private

- (NSString *)contactName:(APContact *)contact
{
    if (contact.compositeName) {
        return contact.compositeName;
    } else if (contact.firstName && contact.lastName) {
        return [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    } else if (contact.firstName || contact.lastName) {
        return contact.firstName ?: contact.lastName;
    } else {
        return @"Untitled contact";
    }
}

@end
