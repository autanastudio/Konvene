//
//  KLEventPaymentActionPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentActionPageCell.h"
#import "KLActivityIndicator.h"



@implementation KLEventPaymentActionPageCell

- (void)awakeFromNib
{
    _color = [UIColor colorFromHex:0x0494b3];
    _labelTicketsLeft.textColor = [UIColor colorFromHex:0x588fe1];
    _labelTicketsLeft.hidden = YES;
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
    _labelAmount.text = [NSString stringWithFormat:@"$%ld", (long)leftValue.integerValue];
}

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
    KLEventPrice *price = self.event.price;
    KLEventPricingType priceType = price.pricingType.intValue;
    
    if (priceType == KLEventPricingTypePayed) {
        
        [self setLeftValue:price.pricePerPerson];
        
        if (price.maximumTickets.intValue - price.soldTickets.integerValue == 0)
        {
            _viewSoldOut.hidden = NO;
            _viewAction.alpha = 0;
            _constraintHeight.constant = 40;
        }
        else if (price.maximumTickets.intValue - price.soldTickets.integerValue < 10)
        {
            _viewSoldOut.hidden = YES;
            _viewAction.alpha = 1;
            _labelTicketsLeft.text = [NSString stringWithFormat:@"%d left!", (int)(price.maximumTickets.intValue - price.soldTickets.integerValue)];
            _button.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
            _labelTicketsLeft.hidden = NO;
        }
        else {
            _viewSoldOut.hidden = YES;
            _viewAction.alpha = 1;
            _labelTicketsLeft.hidden = YES;
        }
    }
    else if (priceType == KLEventPricingTypeThrow) {
        
        [self setLeftValue:price.throwIn];
    }
}

- (void)setLoading:(BOOL)loading
{
    if (loading) {
        
        _activity = [KLActivityIndicator whiteIndicator];
        [_viewMain addSubview:_activity];
        [_activity autoCenterInSuperview];
        [_activity setAnimating:YES];
        
        _button.hidden = YES;
        _labelTicketsLeft.alpha = 0;
    }
    else
    {
        [_activity removeFromSuperview];
        _activity = nil;
        _button.hidden = NO;
        _labelTicketsLeft.alpha = 1;
    }
}


@end
