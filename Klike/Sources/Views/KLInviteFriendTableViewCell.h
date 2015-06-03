//
//  InviteFriendTableViewCell.h
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLInviteFriendTableViewCell, APContact, KLUserWrapper;

typedef NS_ENUM(NSInteger, KLCellType)
{
    KLCellTypeFollow,
    KLCellTypeEvent
};

@protocol KLInviteUserCellDelegate <NSObject>
- (void) cellDidClickAddUser:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickInviteUser:(KLInviteFriendTableViewCell *)cell;
- (KLEvent*) cellEvent;
@end

@interface KLInviteFriendTableViewCell : UITableViewCell
@property APContact *contact;
@property KLUserWrapper *user;
@property (nonatomic, assign) BOOL registered;
@property (nonatomic, weak) id <KLInviteUserCellDelegate> delegate;

- (void)configureWithContact:(APContact *)contact;
- (void)configureWithUser:(KLUserWrapper *)user withType:(KLCellType)type;
- (void)update;
- (void)setLoading:(BOOL)loading;
+ (NSString *)contactName:(APContact *)contact;
@end
