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
    switch (_type) {
        case KLCellTypeFollow: {
            self.isActive = [[KLAccountManager sharedManager] isFollowing:self.user];
        } break;
        case KLCellTypeEvent: {
            self.isActive = [[KLEventManager sharedManager] isUserInvited:self.user
                                                                  toEvent:[self.delegate cellEvent]];
        } break;
        default:
            break;
    }
    [self updateActiveStatus];
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
    if (user.userImageThumbnail) {
        _imageUserPhoto.file = user.userImageThumbnail;
        [_imageUserPhoto loadInBackground];
    } else {
        _imageUserPhoto.image = [UIImage new];
    }
    _labelUserInitials.text = firstCharacters;
    [self styleButtons];
    switch (_type) {
        case KLCellTypeFollow: {
            self.isActive = [[KLAccountManager sharedManager] isFollowing:self.user];
        } break;
        case KLCellTypeEvent: {
            self.isActive = [[KLEventManager sharedManager] isUserInvited:self.user
                                                                  toEvent:[self.delegate cellEvent]];
        } break;
        default:
            break;
    }
    [self updateActiveStatus];
    [self layoutIfNeeded];
}
- (void)styleButtons
{
    _buttonsHorizontalSpacing.constant = 8;
    _buttonEmailWidth.constant = 56;
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

- (void)updateActiveStatus
{
    NSString *buttonActiveTitle;
    NSString *buttonInactiveTitle;
    switch (_type) {
        case KLCellTypeFollow:{
            buttonInactiveTitle = SFLocalizedString(@"Follow", nil);
            buttonActiveTitle = SFLocalizedString(@"Following", nil);
        }break;
        case KLCellTypeEvent:{
            buttonInactiveTitle = SFLocalizedString(@"Invite", nil);
            buttonActiveTitle = SFLocalizedString(@"Invited", nil);
        }break;
        default:
            break;
    }
    if (self.isActive) {
        [_buttonInvite setImage:[UIImage imageNamed:@"ic_following"]
                           forState:UIControlStateNormal];
        [_buttonInvite setBackgroundImage:[UIImage imageNamed:@"btn_small_filled"]
                                     forState:UIControlStateNormal];
        [_buttonInvite setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [_buttonInvite setTitle:buttonActiveTitle
                           forState:UIControlStateNormal];
    } else {
        [_buttonInvite setImage:nil
                           forState:UIControlStateNormal];
        [_buttonInvite setBackgroundImage:[UIImage imageNamed:@"btn_small_stroke"]
                                     forState:UIControlStateNormal];
        [_buttonInvite setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [_buttonInvite setTitle:buttonInactiveTitle
                           forState:UIControlStateNormal];
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
