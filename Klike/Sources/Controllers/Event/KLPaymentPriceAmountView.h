//
//  KLPaymentPriceAmountView.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPaymentPriceAmountView : UIView <UITextFieldDelegate> {
    
    IBOutlet UILabel *_labelDollar;
    IBOutlet UITextField *_textPrice;
    IBOutlet UIView *_viewSeparator;
    IBOutlet UILabel *_labelMin;
    IBOutlet UIView *_viewBottom;
    IBOutlet NSLayoutConstraint *_constraintTextW;
    
    int _number;
}

@property (nonatomic) NSDecimalNumber *minimum;

+ (KLPaymentPriceAmountView*)priceAmountView;
- (NSNumber*)number;

- (void)startAppearAnimation;
- (void)startDisappearAnimation;
- (void)resetAnimation;

@end
