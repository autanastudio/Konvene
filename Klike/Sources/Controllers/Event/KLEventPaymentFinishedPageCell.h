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



@interface UIImage (UIImageFunctions)

- (UIImage*)filteredImage;
- (UIImage*)scaleToFillSize: (CGSize)size;

@end



@interface KLEventPaymentFinishedPageCell : KLEventPageCell {
    IBOutlet UIImageView *_imageCornerL;
    IBOutlet UIView *_viewBackground;
    IBOutlet UIImageView *_imageCorner;
    IBOutlet UIImageView *_imageEvent;
    IBOutlet UIImageView *_imageEventDirt;
    
    IBOutlet UILabel *_labelTickets;
    IBOutlet UILabel *_labelTicketsBottom;
    
    IBOutlet UILabel *_labelThrowedIn;
    
    UIColor *_color;
}

- (void)setEventImage:(UIImage*)image;
- (void)setThrowInInfo;
- (void)setBuyTicketsInfo;
- (void)setTickets:(int)value;
- (void)setThrowedIn:(int)value;

@end
