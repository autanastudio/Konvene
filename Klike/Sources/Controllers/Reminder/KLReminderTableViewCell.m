//
//  KLReminderTableViewCell.m
//  Klike
//
//  Created by Anton Katekov on 12.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLReminderTableViewCell.h"

@implementation KLReminderTableViewCell

- (void)awakeFromNib
{
    UIView *view = [[UIView alloc] initForAutoLayout];
    [self addSubview:view];
    [view autoSetDimension:ALDimensionHeight toSize:0.5];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [view setBackgroundColor:[UIColor colorFromHex:0xe8e8ed]];
}

- (void)setType:(KLEventReminderType)type
{
    _type = type;
    NSString *l = [NSString stringWithFormat:@"reminders%d", (int)type];
    _labelName.text = SFLocalized(l);
    
    _switch.on = [self.delegate stateForReminderTableViewCell:self];
}

- (IBAction)onSwitch:(UISwitch*)sender
{
    [self.delegate reminderTableViewCell:self didChangeState:sender.on];
}

@end
