//
//  KLPayedPricingView.h
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPricingView.h"

@interface KLPayedPricingView : KLPricingView

@property (weak, nonatomic) IBOutlet UITextField *priceInput;
@property (weak, nonatomic) IBOutlet UITextField *ticketInput;
//@property (weak, nonatomic) IBOutlet UILabel *processingLabel;
//@property (weak, nonatomic) IBOutlet UILabel *youGetLabel;
//@property (weak, nonatomic) IBOutlet UILabel *userChargeLabel;

@property (nonatomic, assign) CGFloat processing;

@end
