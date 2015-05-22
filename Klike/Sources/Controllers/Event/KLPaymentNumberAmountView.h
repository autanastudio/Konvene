//
//  KLPaymentNumberAmountView.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPaymentNumberAmountView : UIView <UITextFieldDelegate> {
    
    IBOutlet UITextField *_textPrice;
    IBOutlet UIView *_viewSeparator;
    IBOutlet UILabel *_lavelTickets;
    IBOutlet NSLayoutConstraint *_constraintTextW;
}

@property (nonatomic) int number;

+ (KLPaymentNumberAmountView*)paymentNumberAmountView;

@end
