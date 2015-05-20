//
//  KLPaymentHistoryCell.m
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentHistoryCell.h"

@interface KLPaymentHistoryCell ()

@property (weak, nonatomic) IBOutlet PFImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation KLPaymentHistoryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithCharge:(KLCharge *)charge
{
    KLEvent *event = charge.event;
    if (event.backImage) {
        self.eventImage.file = event.backImage;
        [self.eventImage loadInBackground];
    } else {
        self.eventImage.image = [UIImage imageNamed:@"event_pic_placeholder"];
    }
    self.eventTitle.text = event.title;
    
    KLEventPrice *price = event.price;
    
    NSString *amountString = [NSString stringWithFormat:@"$%ld", (long)[charge.amount integerValue]];
    UIFont *descriptionFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    if ([price.pricingType integerValue] == KLEventPricingTypePayed) {
        NSString *forString = @" for ";
        NSString *ticketCount = [NSString stringWithFormat:@"%ld", [charge.amount integerValue]/[price.pricePerPerson integerValue]];
        NSString *descriptionText = [NSString stringWithFormat:@" tickets with XXXX-%@", charge.card.last4];
        
        KLAttributedStringPart *price = [KLAttributedStringPart partWithString:amountString
                                                                         color:[UIColor blackColor]
                                                                          font:descriptionFont];
        KLAttributedStringPart *forPart = [KLAttributedStringPart partWithString:forString
                                                                               color:[UIColor colorFromHex:0xb3b3bd]
                                                                                font:descriptionFont];
        KLAttributedStringPart *tickets = [KLAttributedStringPart partWithString:ticketCount
                                                                         color:[UIColor blackColor]
                                                                          font:descriptionFont];
        KLAttributedStringPart *description = [KLAttributedStringPart partWithString:descriptionText
                                                                               color:[UIColor colorFromHex:0xb3b3bd]
                                                                                font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[price, forPart, tickets, description]];
    } else {
        NSString *descriptionText = [NSString stringWithFormat:@" throwin in with XXXX-%@", charge.card.last4];
        
        KLAttributedStringPart *price = [KLAttributedStringPart partWithString:amountString
                                                                        color:[UIColor blackColor]
                                                                         font:descriptionFont];
        KLAttributedStringPart *description = [KLAttributedStringPart partWithString:descriptionText
                                                                              color:[UIColor colorFromHex:0xb3b3bd]
                                                                               font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[price, description]];
    }
    
    self.timeLabel.text = [NSString stringTimeSinceDate:charge.createdAt];
}


@end
