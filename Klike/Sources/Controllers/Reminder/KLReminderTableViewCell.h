//
//  KLReminderTableViewCell.h
//  Klike
//
//  Created by Anton Katekov on 12.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KLReminderTableViewCell;



@protocol KLReminderTableViewCellDelegate <NSObject>

- (void)reminderTableViewCell:(KLReminderTableViewCell*)cell didChangeState:(BOOL)state;
- (BOOL)stateForReminderTableViewCell:(KLReminderTableViewCell*)cell;

@end


@interface KLReminderTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_labelName;
    IBOutlet UISwitch *_switch;
}

@property (weak)id<KLReminderTableViewCellDelegate>delegate;
@property (nonatomic) KLEventReminderType type;

@end
