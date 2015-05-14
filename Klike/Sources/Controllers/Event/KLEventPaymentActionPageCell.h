//
//  KLEventPaymentActionPageCell.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



typedef NS_ENUM(NSUInteger, KLEventPaymentActionPageCellType) {
    KLEventPaymentActionPageCellTypeThrow,
    KLEventPaymentActionPageCellTypeBuy,
};



@interface KLEventPaymentActionPageCell : KLEventPageCell {
    IBOutlet UIImageView *_imageBackground1;
    IBOutlet UIImageView *_imageBackground;
    IBOutlet UILabel *_labelAmount;
    IBOutlet UILabel *_labelAmountDescription;
    IBOutlet UIButton *_button;
    
    UIColor *_color;
}

- (void)setThrowInInfo;
- (void)setBuyTicketsInfo;

@end
