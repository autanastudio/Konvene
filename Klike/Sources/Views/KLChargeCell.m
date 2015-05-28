//
//  KLChargeCell.m
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLChargeCell.h"

@interface KLChargeCell ()

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ticketIconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation KLChargeCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
}

- (void)configureWithCharge:(KLCharge *)charge
{
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:charge.owner];
    self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    self.userImageView.file = user.userImage;
    [self.userImageView loadInBackground];
    self.userNameLabel.text = user.fullName;
    
    self.timeLabel.text = [NSString stringTimeSinceDate:charge.createdAt];
    
    KLEvent *event = charge.event;
    if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
        self.ticketIconView.hidden = NO;
        NSInteger tickets = [charge.amount integerValue]/[event.price.pricePerPerson integerValue];
        self.amountLabel.text = [NSString stringWithFormat:@"%ld", (long)tickets];
    } else {
        self.ticketIconView.hidden = YES;
        self.amountLabel.text = [NSString stringWithFormat:@"$%ld", (long)[charge.amount integerValue]];
    }
}

@end
