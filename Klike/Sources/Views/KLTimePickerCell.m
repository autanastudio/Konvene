//
//  KLTimePickerCell.m
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTimePickerCell.h"
#import "KLDatePickerView.h"

@interface KLTimePickerCell ()
@property (nonatomic, strong) KLDatePickerView *pickerView;
@end

@implementation KLTimePickerCell

@synthesize date = _date;
@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pickerView = [[KLDatePickerView alloc] initForAutoLayout];
        [self.contentView addSubview:self.pickerView];
        [self.pickerView autoSetDimension:ALDimensionHeight
                                   toSize:240];
        [self.pickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.pickerView addTarget:self
                            action:@selector(onTimeChanged:)
                  forControlEvents:UIControlEventValueChanged];
        self.pickerView.date = self.pickerView.date;
    }
    return self;
}

- (void)onTimeChanged:(NSDate *)date
{
    if ([self.delegate respondsToSelector:@selector(calendarCell:didSelectDate:)]) {
        [self.delegate calendarCell:self
                      didSelectDate:self.pickerView.date];
    }
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (void)setDate:(NSDate *)date
{
    if (date) {
        _date = date;
        [self.pickerView setDate:_date];
    }
}

- (void)setMinimalDate:(NSDate *)minimalDate
{
    [self.pickerView setMinimalDate:minimalDate];
}

@end
