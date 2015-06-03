//
//  InviteFriendTableViewCell.m
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteFriendTableViewCell.h"
#import <APAddressBook/APContact.h>
#import "KLActivityIndicator.h"



@implementation KLInviteFriendTableViewCell
{
    IBOutlet PFImageView *_imageUserPhoto;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UILabel *_labelUserInitials;
    IBOutlet UIButton *_buttonInvite;
    KLActivityIndicator *_activity;
    IBOutlet UIButton *_buttonSendEmail;
    IBOutlet UIButton *_buttonSendSMS;
    
    IBOutlet NSLayoutConstraint *_buttonsHorizontalSpacing;
    IBOutlet NSLayoutConstraint *_buttonEmailWidth;
    IBOutlet NSLayoutConstraint *_buttonInviteWidth;
    
    KLCellType _type;
}

- (void)configureWithContact:(APContact *)contact
{
    self.contact = contact;
    _labelUserName.text = [KLInviteFriendTableViewCell contactName:self.contact];
    NSString *firstChar = self.contact.firstName.length > 0 ? [self.contact.firstName substringToIndex:1] : @"";
    NSString *secondChar = self.contact.lastName.length > 0 ? [self.contact.lastName substringToIndex:1] : @"";
    NSString *firstCharacters = [firstChar stringByAppendingString:secondChar];
    _labelUserInitials.text = firstCharacters;
    if (contact.thumbnail)
        _imageUserPhoto.image = contact.thumbnail;
    else {
        _imageUserPhoto.image = [UIImage new];
    }
    [self styleButtons];
    [self update];
}

- (void)configureWithUser:(KLUserWrapper *)user withType:(KLCellType)type
{
    [self setLoading:NO];
    _type = type;
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
    if (user.userImage) {
        _imageUserPhoto.file = user.userImage;
        [_imageUserPhoto loadInBackground];
    } else {
        _imageUserPhoto.image = [UIImage new];
    }
    _labelUserInitials.text = firstCharacters;
    [self styleButtons];
    switch (type) {
        case KLCellTypeFollow:
            _buttonInviteWidth.constant = 86;
            [_buttonInvite setTitle:SFLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
            [_buttonInvite setTitle:SFLocalizedString(@"Following", nil) forState:UIControlStateHighlighted];
            break;
        case KLCellTypeEvent:
            _buttonInviteWidth.constant = 77;
            [_buttonInvite setTitle:SFLocalizedString(@"Invite", nil) forState:UIControlStateNormal];
            [_buttonInvite setTitle:SFLocalizedString(@"Invited", nil) forState:UIControlStateHighlighted];
        default:
            break;
    }
    [self update];
}
- (void)styleButtons
{
    _buttonsHorizontalSpacing.constant = 8;
    _buttonEmailWidth.constant = 56;
    _buttonInvite.layer.cornerRadius = 12;
    _buttonInvite.layer.borderWidth = 1.5;
    _buttonInvite.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    [_buttonInvite setTitleColor:[UIColor colorFromHex:0x6466ca]
                        forState:UIControlStateNormal];
    [_buttonInvite setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
    _buttonInvite.clipsToBounds = YES;
    _buttonSendEmail.layer.cornerRadius = 12;
    _buttonSendEmail.layer.borderWidth = 1.5;
    _buttonSendEmail.layer.borderColor = [UIColor colorFromHex:0x6466ca].CGColor;
    _buttonSendSMS.layer.cornerRadius = 12;
    _buttonSendSMS.layer.borderWidth = 1.5;
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
    switch (_type) {
        case KLCellTypeFollow:
            if ([self.delegate respondsToSelector:@selector(cellDidClickAddUser:)]) {
                [self.delegate cellDidClickAddUser:self];
            }
            break;
        case KLCellTypeEvent:
            if ([self.delegate respondsToSelector:@selector(cellDidClickInviteUser:)]) {
                [self.delegate cellDidClickInviteUser:self];
            }
            break;
            
        default:
            break;
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

+ (NSString *)contactName:(APContact *)contact
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

- (void) update
{
    switch (_type) {
        case KLCellTypeFollow:
        {
            if ([[KLAccountManager sharedManager] isFollowing:self.user]) {
                _buttonInvite.highlighted = YES;
                _buttonInvite.backgroundColor = [UIColor colorFromHex:0x6466ca];
            } else {
                _buttonInvite.highlighted = NO;
                _buttonInvite.backgroundColor = [UIColor colorFromHex:0xffffff];
            }
        }    break;
        case KLCellTypeEvent:
        {
            if ([[KLEventManager sharedManager] isUserInvited:self.user
                                                      toEvent:[self.delegate cellEvent]]) {
                _buttonInvite.highlighted = YES;
                _buttonInvite.backgroundColor = [UIColor colorFromHex:0x6466ca];
            } else {
                _buttonInvite.highlighted = NO;
                _buttonInvite.backgroundColor = [UIColor colorFromHex:0xffffff];
            }
        }    break;
        default:
            break;
    }
    
    
}

- (void)setLoading:(BOOL)loading
{
    _buttonInvite.hidden = loading;
    if (loading) {
        _activity = [KLActivityIndicator colorIndicator];
        [self.contentView addSubview:_activity];
        [_activity autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_buttonInvite];
        [_activity autoAlignAxis:ALAxisVertical toSameAxisOfView:_buttonInvite];
        [_activity setAnimating:YES];
    }
    else
    {
        [_activity removeFromSuperview];
        _activity = nil;
    }
}

@end
