//
//  KLPaymentPriceAmountView.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPaymentPriceAmountView : UIView <UITextFieldDelegate> {
    
    IBOutlet UITextField *_textPrice;
    IBOutlet UIView *_viewSeparator;
    IBOutlet UILabel *_labelMin;
    IBOutlet NSLayoutConstraint *_constraintTextW;
}

@property (nonatomic) NSDecimalNumber *minimum;

+ (KLPaymentPriceAmountView*)priceAmountView;
- (NSNumber*)number;

@end
