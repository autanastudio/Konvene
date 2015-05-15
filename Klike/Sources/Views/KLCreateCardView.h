//
//  KLCreateCardView.h
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KLCardValidStatusCardNumber   = (1 << 0), // => 00000001
    KLCardValidStatusExpire       = (1 << 1), // => 00000010
    KLCardValidStatusCVS          = (1 << 2)  // => 00000100
} KLCardValidStatus;

@class SFTextField, KLCreateCardView, STPCard;

@protocol KLCreateCardViewDelegate <NSObject>

- (void)showScanCardControllerCardView:(KLCreateCardView *)view;
- (void)showCSVInfoControllerCardView:(KLCreateCardView *)view;
- (void)cardChangeValidCardControllerCardView:(KLCreateCardView *)view;

@end

@interface KLCreateCardView : UIView

@property (nonatomic, weak) id<KLCreateCardViewDelegate> deleagate;

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *linesColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *buttonTintColor;
@property (nonatomic, strong) UIColor *errorColor;

@property (weak, nonatomic) IBOutlet SFTextField *cardNumberField;
@property (weak, nonatomic) IBOutlet SFTextField *expireDateField;
@property (weak, nonatomic) IBOutlet SFTextField *keyField;

@property (nonatomic, assign) KLCardValidStatus validateStatus;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL valid;


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lines;

@property (weak, nonatomic) IBOutlet UIButton *camButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (nonatomic, strong) STPCard *card;

- (void)configureColorsForSettings;

- (void)setCardNumber:(NSString *)cardNumberString;

@end
