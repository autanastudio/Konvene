//
//  InviteFriendTableViewCell.h
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLInviteFriendTableViewCell, APContact;

@protocol KLInviteUserCellDelegate <NSObject>
- (void) cellDidClickAddUser:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell;
@end

@interface KLInviteFriendTableViewCell : UITableViewCell
@property APContact *contact;
@property (nonatomic, assign) BOOL registered;
@property (nonatomic, weak) id <KLInviteUserCellDelegate> delegate;

- (void)configureWithContact:(APContact *)contact;

@end
