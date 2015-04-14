//
//  KLDateCell.m
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLDateCell.h"
#import "NSDate+MTDates.h"

@interface KLDateCell ()
@property(nonatomic, strong) NSLayoutConstraint *buttonWidthContraint;
@property(nonatomic, strong) UIButton *clearButton;
@end

static CGFloat klClearButtonWidth = 24.;


@implementation KLDateCell

@synthesize value = _value;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       title:(NSString *)title
                       value:(id)value
{
    self = [super initWithName:name
                   placeholder:nil
                         image:image
                         value:value];
    if (self) {
        self.showShortDate = NO;
        self.showDeleteValueButton = NO;
        
        self.minimumHeight = 48.;
        self.title = title;
        
        self.titleLabel = [[UILabel alloc] initForAutoLayout];
        self.titleLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                size:14.];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.text = self.title;
        
        self.valueLabel = [[UILabel alloc] initForAutoLayout];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                size:14.];
        self.valueLabel.textColor = [UIColor colorFromHex:0xb3b3bd];
        [self.contentView addSubview:self.valueLabel];
        
        self.clearButton = [[UIButton alloc] init];
        self.clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.clearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.clearButton setImage:[UIImage imageNamed:@"ic_delete_date"]
                          forState:UIControlStateNormal];
        [self.clearButton addTarget:self
                             action:@selector(clear)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.clearButton];
        self.buttonWidthContraint = [self.clearButton autoSetDimension:ALDimensionWidth
                                                                toSize:0];
        
        self.value = value;
    }
    return self;
}

- (void)clear
{
    [self setValue:nil];
}

- (void)setShowShortDate:(BOOL)showShortDate
{
    _showShortDate = showShortDate;
    [self setValue:_value];
}

- (void)showClearButton
{
    self.buttonWidthContraint.constant = klClearButtonWidth;
}

- (void)hideClearButton
{
    self.buttonWidthContraint.constant = 0.;
}

- (void)setValue:(id)value
{
    _value = value;
    NSDate *date = (NSDate *)value;
    if (date) {
        if (self.showShortDate) {
            self.valueLabel.text = [date mt_stringFromDateWithFormat:@"hh:mm aaa" localized:NO];
        } else{
            self.valueLabel.text = [date mt_stringFromDateWithFormat:@"MMM d, hh:mm aaa" localized:NO];
        }
        if (self.showDeleteValueButton) {
            [self showClearButton];
        }
    } else {
        self.valueLabel.text = @"None";
        [self hideClearButton];
    }
}

- (void)_updateViewsConfiguration
{
    [super _updateViewsConfiguration];
    
    UIEdgeInsets contentInsets = self.contentInsets;
    contentInsets.top = 16. + contentInsets.top;
    self.contentInsets = contentInsets;
}

- (void)_updateConstraints
{
    [super _updateConstraints];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                      withInset:self.contentInsets.left];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    
    [self.clearButton autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:self.contentInsets.right];
    [self.clearButton autoPinEdgeToSuperviewEdge:ALEdgeTop
                                       withInset:0.];
    [self.clearButton autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                       withInset:0.];
    [self.valueLabel autoPinEdge:ALEdgeLeft
                          toEdge:ALEdgeRight
                          ofView:self.titleLabel];
}

- (void)calendarCell:(KLTimePickerCell *)cell
       didSelectDate:(NSDate *)date
{
    self.value = date;
}

@end
