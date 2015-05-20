//
//  KLEventPaymentActionPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentActionPageCell.h"



@implementation KLEventPaymentActionPageCell

- (void)awakeFromNib
{
    _color = [UIColor colorFromHex:0x0494b3];
}

- (void)setType:(KLEventPaymentActionPageCellType)type
{
    if (type == KLEventPaymentActionPageCellTypeBuy)
    {
        _color = [UIColor colorFromHex:0x6466ca];
        _imageBackground.image = [UIImage imageNamed:@"p_btn_buy_ticket"];
        _imageBackground1.image = [UIImage imageNamed:@"p_btn_buy_ticket"];
        _labelAmountDescription.text = @"per ticket";
//        _labelAmount.text = @"$40";
        _labelAmount.textColor = [UIColor colorFromHex:0x346bbd];
        [_button setImage:[UIImage imageNamed:@"p_ic_ticket"] forState:UIControlStateNormal];
        [_button setTitle:@"Buy Tickets" forState:UIControlStateNormal];
        
    }
    else
    {
        _color = [UIColor colorFromHex:0x0494b3];
        _imageBackground.image = [UIImage imageNamed:@"p_btn_throw_in"];
        _imageBackground1.image = [UIImage imageNamed:@"p_btn_throw_in"];
        _labelAmountDescription.text = @"gathered";
//        _labelAmount.text = @"$40";
        _labelAmount.textColor = [UIColor colorFromHex:0x0494b3];
        [_button setImage:[UIImage imageNamed:@"p_ic_throw_in"] forState:UIControlStateNormal];
        [_button setTitle:@"Throw In" forState:UIControlStateNormal];
        
    }
}

- (void)setThrowInInfo
{
    [self setType:(KLEventPaymentActionPageCellTypeThrow)];
}

- (void)setBuyTicketsInfo
{
    [self setType:(KLEventPaymentActionPageCellTypeBuy)];
}

- (IBAction)onAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(paymentActionCellDidPressAction)]) {
        [self.delegate performSelector:@selector(paymentActionCellDidPressAction) withObject:nil];
    }
}

- (void)setLeftValue:(NSNumber*)leftValue
{
    _labelAmount.text = [@"$" stringByAppendingString:leftValue.description];
}

@end
