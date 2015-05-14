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
    IBOutlet UIImageView *_imageCornerL;
    IBOutlet UIView *_viewBackground;
    IBOutlet UIImageView *_imageCorner;
    IBOutlet UIImageView *_imageEvent;
    
    IBOutlet UILabel *_labelTickets;
    IBOutlet UILabel *_labelTicketsBottom;
    
    
    IBOutlet UILabel *_labelThrowedIn;
    
    UIColor *_color;
}

- (void)setEventImage:(UIImage*)image;
- (void)setThrowInInfo;
- (void)setBuyTicketsInfo;

@end
