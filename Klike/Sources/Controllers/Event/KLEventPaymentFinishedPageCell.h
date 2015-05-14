//
//  KLEventPaymentFinishedPageCell.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



typedef NS_ENUM(NSUInteger, KLEventPaymentFinishedPageCellType) {
    KLEventPaymentFinishedPageCellTypeThrow,
    KLEventPaymentFinishedPageCellTypeBuy,
};



@interface KLEventPaymentFinishedPageCell : KLEventPageCell {
    IBOutlet UIView *_viewBackground;
    IBOutlet UIImageView *_imageCorner;
    
    UIColor *_color;
}

- (void)setEventImage:(UIImage*)image;
- (void)setThrowInInfo;
- (void)setBuyTicketsInfo;

@end
