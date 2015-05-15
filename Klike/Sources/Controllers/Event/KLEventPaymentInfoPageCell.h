//
//  KLEventPaymentInfoPageCell.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



typedef NS_ENUM(NSUInteger, KLEventPaymentInfoPageCellType) {
    KLEventPaymentInfoPageCellTypeThrow,
    KLEventPaymentInfoPageCellTypeBuy,
};



@class KLPaymentPriceAmountView;
@class KLPaymentNumberAmountView;



@interface KLEventPaymentInfoPageCell : KLEventPageCell <UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UIButton *_buttonClose;
    IBOutlet UILabel *_labelCardNumber;
    IBOutlet UIView *_viewInputContent;
    IBOutlet UICollectionView *_collectionCards;
    IBOutlet UICollectionViewFlowLayout *_colletctionLayout;
    IBOutlet UIPageControl *_pages;
    IBOutlet NSLayoutConstraint *_constraintCellH;
    
    KLPaymentPriceAmountView *_viewPriceAmount;
    KLPaymentNumberAmountView *_viewNumberAmount;
    
    UIColor *_color;
    BOOL _buy;
}

- (void)setOneCard;
- (void)setMultipleCards;

- (void)setThrowIn;
- (void)setBuy;

@end
