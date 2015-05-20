//
//  KLPaymentBaseViewController.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KLPaymentPriceAmountView;
@class KLPaymentNumberAmountView;
@class KLCreateCardView;



@protocol KLPaymentBaseViewControllerDelegate <NSObject>

- (void)paymentBaseViewControllerDidFinishPayment;

@end



@interface KLPaymentBaseViewController : UIViewController {
    IBOutlet UIImageView *_imageBackground1;
    IBOutlet UIImageView *_imageBackground2;
    IBOutlet UIImageView *_imageBackground;
    IBOutlet UILabel *_labelAmount;
    IBOutlet UILabel *_labelAmountDescription;
    IBOutlet UIButton *_button;
    IBOutlet UIView *_viewInputConyeny;
    IBOutlet UILabel *_labelHeader;
    IBOutlet UIView *_viewCard;
    KLCreateCardView *_viewCardInternal;
    IBOutlet UIView *_viewBlock;
    IBOutlet UIActivityIndicatorView *_activity;
    
    IBOutlet NSLayoutConstraint *_constraintBottom;
    KLPaymentPriceAmountView *_viewPriceAmount;
    KLPaymentNumberAmountView *_viewNumberAmount;
    
    UIColor *_color;
}

@property (nonatomic) KLEvent *event;
@property (nonatomic) BOOL throwInStyle;
@property (nonatomic) id<KLPaymentBaseViewControllerDelegate> delegate;

- (IBAction)onClose:(id)sender;

@end
