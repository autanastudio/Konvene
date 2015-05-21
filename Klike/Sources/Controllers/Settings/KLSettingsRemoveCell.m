//
//  KLSettingsRemoveCell.m
//  Klike
//
//  Created by Katekov Anton on 21.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSettingsRemoveCell.h"



@implementation KLSettingsRemoveView

- (void)awakeFromNib
{
    [_buttonLogout setImage:nil
                   forState:UIControlStateNormal];
    [_buttonLogout setBackgroundImage:[UIImage imageNamed:@"btn_big_stroke"]
                             forState:UIControlStateNormal];
    [_buttonLogout setTitleColor:[UIColor colorFromHex:0x6466ca]
                        forState:UIControlStateNormal];
    
    
    [_buttonDelete setTitleColor:[UIColor colorFromHex:0x6466ca]
                        forState:UIControlStateNormal];
    

}

- (IBAction)onLogout:(id)sender
{
    [self.delegate settingsRemoveViewDidPressLogout];
}

- (IBAction)onDelete:(id)sender
{
    [self.delegate settingsRemoveViewDidPressDelete];
}

@end
