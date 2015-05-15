//
//  KLCardCell.m
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCardCell.h"

@implementation KLCardCell

- (void)awakeFromNib
{
    self.cardBGView.layer.cornerRadius = 8.;
}

- (void)configureWithCard:(KLCard *)card
{
    self.cardNameLabel.text = card.brand;
    self.cardNumberLabel.text = [NSString stringWithFormat:@"XXXX — %@", card.last4];
}

@end
