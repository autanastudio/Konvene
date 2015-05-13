//
//  KLPushSettingsTableViewCell.m
//  Klike
//
//  Created by Katekov Anton on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPushSettingsTableViewCell.h"

@implementation KLPushSettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *view = [[UIView alloc] initForAutoLayout];
    [self addSubview:view];
    [view autoSetDimension:ALDimensionHeight toSize:0.5];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [view setBackgroundColor:[UIColor colorFromHex:0xe8e8ed]];
}

- (void)setType:(int)type
{
    _type = type;
    NSString *l = [NSString stringWithFormat:@"reminders%d", (int)type];
    _labelName.text = SFLocalized(l);
    
    _switch.on = [self.delegate stateForPushSettingsTableViewCell:self];
}

- (IBAction)onSwitch:(UISwitch*)sender
{
    [self.delegate pushSettingsTableViewCell:self didChangeState:sender.on];
}

@end
