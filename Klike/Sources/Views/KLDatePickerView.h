//
//  KLDatePickerView.h
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLDatePickerView : UIControl
// Setter should be called after picker has valid explicit size constraints;
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, strong) NSDate *minimalDate;
@end
