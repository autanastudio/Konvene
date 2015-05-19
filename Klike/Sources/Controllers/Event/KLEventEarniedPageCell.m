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

- (void)setType:(KLEventEarniedPageCellType)type numbers:(NSArray*)numbers
{
    if (type == KLEventEarniedPageCellPayd)
    {
        _constraintViewFreeH.constant = 56;
        _constraintViewPaidH.constant = 56;
        _viewFree.hidden = YES;
        _viewPaid.hidden = NO;
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        
        _labelBottom1.text = @"per ticket";
        _labelBottom1.text = @"you get";
        _labelBottom1.text = @"sold";
        _labelTop1.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:0] intValue]];
        _labelTop2.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:1] intValue]];
        _labelTop3.text = [NSString stringWithFormat:@"%d", [[numbers objectAtIndex:2] intValue]];
    }
    else if (type == KLEventEarniedPageCellPayd)
    {
        _constraintViewFreeH.constant = 56;
        _constraintViewPaidH.constant = 56;
        _viewFree.hidden = YES;
        _viewPaid.hidden = NO;
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        
        _labelBottom1.text = @"gathered";
        _labelBottom1.text = @"you get";
        _labelBottom1.text = @"threw in";
        _labelTop1.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:0] intValue]];
        _labelTop2.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:1] intValue]];
        _labelTop3.text = [NSString stringWithFormat:@"%d", [[numbers objectAtIndex:2] intValue]];
    }
    else
    {
        _viewFree.hidden = NO;
        _viewPaid.hidden = YES;
        _constraintViewFreeH.constant = 40;
        _constraintViewPaidH.constant = 40;
    }
}

@end
