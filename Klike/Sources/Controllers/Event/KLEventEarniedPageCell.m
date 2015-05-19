//
//  KLEventEarniedPageCell.m
//  Klike
//
//  Created by Katekov Anton on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventEarniedPageCell.h"

@implementation KLEventEarniedPageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setType:(KLEventEarniedPageCellType)type
{
    if (type == KLEventEarniedPageCellPayd) {
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        
        _labelBottom1.text = @"per ticket";
        _labelBottom1.text = @"you get";
        _labelBottom1.text = @"sold";
    }
    else {
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        
        _labelBottom1.text = @"gathered";
        _labelBottom1.text = @"you get";
        _labelBottom1.text = @"threw in";
    }
}

@end
