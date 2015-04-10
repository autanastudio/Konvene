//
//  KLPayedPricingController.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPayedPricingController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *priceInput;
@property (weak, nonatomic) IBOutlet UILabel *processingLabel;
@property (weak, nonatomic) IBOutlet UILabel *youGetLabel;

@property (nonatomic, assign) CGFloat processing;

@end
