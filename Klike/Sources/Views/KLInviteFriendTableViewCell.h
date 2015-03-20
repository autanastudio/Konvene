//
//  InviteFriendTableViewCell.h
//  Klike
//
//  Created by Dima on 19.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//
@class KLInviteFriendTableViewCell;

#import <UIKit/UIKit.h>
@protocol KLInviteUserCellDelegate <NSObject>
- (void) cellDidClickAddUser:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell;
- (void) cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell;
@end

@interface KLInviteFriendTableViewCell : UITableViewCell
@property PFUser *user;
@property (nonatomic, assign) BOOL registered;
@property (nonatomic, weak) id <KLInviteUserCellDelegate> delegate;

- (void) configureWithUser:(PFUser *)user;

@end
