//
//  KLPushSettingsTableViewCell.h
//  Klike
//
//  Created by Katekov Anton on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KLPushSettingsTableViewCell;



@protocol KLPushSettingsTableViewCellDelegate <NSObject>

- (void)pushSettingsTableViewCell:(KLPushSettingsTableViewCell*)cell didChangeState:(BOOL)state;
- (BOOL)stateForPushSettingsTableViewCell:(KLPushSettingsTableViewCell*)cell;

@end



@interface KLPushSettingsTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_labelName;
    IBOutlet UISwitch *_switch;
}

@property (weak)id<KLPushSettingsTableViewCellDelegate>delegate;
@property (nonatomic) int type;

@end
