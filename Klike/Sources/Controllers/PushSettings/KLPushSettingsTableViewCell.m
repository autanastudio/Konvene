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

- (IBAction)onSwitch:(UISwitch*)sender
{
    [self.delegate pushSettingsTableViewCell:self didChangeState:sender.on];
}

- (void)setName:(NSString*)name enabled:(BOOL)enabled
{
    _labelName.text = name;
    _switch.on = enabled;
}

@end
