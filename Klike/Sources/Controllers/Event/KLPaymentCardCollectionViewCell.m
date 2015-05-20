//
//  KLPaymentCardCollectionViewCell.m
//  Klike
//
//  Created by Anton Katekov on 15.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentCardCollectionViewCell.h"

@implementation KLPaymentCardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setThrowIn
{
    _imageCardBackground.image = [UIImage imageNamed:@"credit_card_bg_throw_in"];
    _labelNumber.textColor = [UIColor colorFromHex:0x15badd];
}

- (void)setBuy
{
    _imageCardBackground.image = [UIImage imageNamed:@"credit_card_bg_buy_ticket"];
    _labelNumber.textColor = [UIColor colorFromHex:0x588fe1];
}

- (void)buildWithCard:(KLCard*)card
{
    _labelName.text = [NSString stringWithFormat:@"%@ %@", card.cardId, [card.brand uppercaseString]];
    _labelNumber.text = [@"XXXX-"stringByAppendingString:card.last4];
}

@end
