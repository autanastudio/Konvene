//
//  KLEventEarniedPageCell.m
//  Klike
//
//  Created by Katekov Anton on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventEarniedPageCell.h"



@implementation KLEventEarniedPageCell

- (void)setType:(KLEventEarniedPageCellType)type numbers:(NSArray*)numbers
{
    if (type == KLEventEarniedPageCellPayd)
    {
        _constraintViewFreeH.constant = 56;
        _constraintViewPaidH.constant = 56;
        _viewFree.hidden = YES;
        _viewPaid.hidden = NO;
        _labelTop1.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop2.textColor = [UIColor colorFromHex:0x346bbd];
        _labelTop3.textColor = [UIColor colorFromHex:0x346bbd];
        
        _labelBottom1.text = @"per ticket";
        _labelBottom2.text = @"you get";
        _labelBottom3.text = @"sold";
        _labelTop1.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:0] intValue]];
        _labelTop2.text = [NSString stringWithFormat:@"$%d", [[numbers objectAtIndex:1] intValue]];
        _labelTop3.text = [NSString stringWithFormat:@"%d", [[numbers objectAtIndex:2] intValue]];
    }
    else if (type == KLEventEarniedPageCellThrow)
    {
        _constraintViewFreeH.constant = 56;
        _constraintViewPaidH.constant = 56;
        _viewFree.hidden = YES;
        _viewPaid.hidden = NO;
        _labelTop1.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop2.textColor = [UIColor colorFromHex:0x0494b3];
        _labelTop3.textColor = [UIColor colorFromHex:0x0494b3];
        
        _labelBottom1.text = @"gathered";
        _labelBottom2.text = @"you get";
        _labelBottom3.text = @"threw in";
        _labelTop1.text = [NSString stringWithFormat:@"$%ld", (long)[[numbers objectAtIndex:0] integerValue]];
        _labelTop2.text = [NSString stringWithFormat:@"$%ld", (long)[[numbers objectAtIndex:1] integerValue]];
        _labelTop3.text = [NSString stringWithFormat:@"%ld", (long)[[numbers objectAtIndex:2] integerValue]];
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
