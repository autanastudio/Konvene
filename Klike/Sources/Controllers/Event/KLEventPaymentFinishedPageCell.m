//
//  KLEventPaymentFinishedPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentFinishedPageCell.h"

@implementation KLEventPaymentFinishedPageCell

- (void)awakeFromNib
{
    _color = [UIColor colorFromHex:0x0494b3];
}

- (void)setType:(KLEventPaymentFinishedPageCellType)type
{
    if (type == KLEventPaymentFinishedPageCellTypeBuy)
    {
        _color = [UIColor colorFromHex:0x6466ca];
        _viewBackground.backgroundColor = _color;
        _imageCorner.image = [UIImage imageNamed:@"p_ticket_m"];
//        _labelAmountDescription.text = @"per ticket";
//        _labelAmount.text = @"$40";
//        _labelAmount.textColor = [UIColor colorFromHex:0x346bbd];
//        [_button setImage:[UIImage imageNamed:@"p_ic_ticket"] forState:UIControlStateNormal];
        
    }
    else
    {
        _color = [UIColor colorFromHex:0x0494b3];
        _viewBackground.backgroundColor = _color;
        _imageCorner.image = [UIImage imageNamed:@"p_ticket_throw_in_m"];
        
//        _labelAmountDescription.text = @"gathered";
//        _labelAmount.text = @"$40";
//        _labelAmount.textColor = [UIColor colorFromHex:0x0494b3];
//        [_button setImage:[UIImage imageNamed:@"p_ic_throw_in"] forState:UIControlStateNormal];
        
    }
}

- (void)setEventImage:(UIImage*)image
{}

- (void)setThrowInInfo
{
    [self setType:(KLEventPaymentFinishedPageCellTypeThrow)];
}

- (void)setBuyTicketsInfo
{
    [self setType:(KLEventPaymentFinishedPageCellTypeBuy)];
}

@end
