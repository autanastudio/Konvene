//
//  KLEventPaymentActionPageCell.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



@class KLActivityIndicator;

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
    IBOutlet UILabel *_labelTicketsLeft;
    IBOutlet UIView *_viewSoldOut;
    IBOutlet UIView *_viewAction;
    IBOutlet UIView *_viewMain;
    
    IBOutlet NSLayoutConstraint *_constraintHeight;
    UIColor *_color;
    
    KLActivityIndicator *_activity;
}

- (void)setThrowInInfo;
- (void)setBuyTicketsInfo;
- (void)setLeftValue:(NSNumber*)leftValue;
- (void)setLoading:(BOOL)loading;

@end
