//
//  KLTimePickerCell.h
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"
#import "KLFormCell_Private.h"

@class KLTimePickerCell;
@protocol KLTimePickerCellDelegate <KLFormCellDelegate>
- (void)calendarCell:(KLTimePickerCell *)cell
       didSelectDate:(NSDate *)date;
@end

@interface KLTimePickerCell : KLFormCell
@property (nonatomic, weak) id<KLTimePickerCellDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

- (void)setMinimalDate:(NSDate *)minimalDate;

@end
