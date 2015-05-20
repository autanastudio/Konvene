//
//  KLPaymentHistoryCell.h
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPaymentHistoryCell : UITableViewCell

- (void)configureWithCharge:(KLCharge *)charge;

@end
