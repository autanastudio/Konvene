//
//  KLDatePickerView.m
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLDatePickerView.h"
#import <MTDates/NSDate+MTDates.h>

static const CGFloat kScrollItemLabelHeight = 48.0;
static const CGFloat kScrollLineWidth = 67.0;
static const CGFloat kPeriodScrollHeight = 1000;

@interface KLDatePickerView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *hoursScroll;
@property (nonatomic, strong) UIScrollView *minutesScroll;
@property (nonatomic, strong) UIScrollView *periodScroll;
@property (nonatomic, strong) UIView *contentContainer;

@property (nonatomic, strong) NSMutableArray *hoursLabels;
@property (nonatomic, strong) NSMutableArray *minutesLabels;
@end

@implementation KLDatePickerView
@synthesize date = _date;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor colorFromHex:0x6466ca];
        
        UIView *focusLine = [[UIView alloc] initForAutoLayout];
        focusLine.backgroundColor = [UIColor clearColor];
        [self addSubview:focusLine];
        [focusLine autoCenterInSuperview];
        [focusLine autoSetDimension:ALDimensionHeight
                             toSize:kScrollItemLabelHeight];
        [focusLine autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                    withInset:0];
        [focusLine autoPinEdgeToSuperviewEdge:ALEdgeRight
                                    withInset:0];
        
        self.contentContainer = [[UIView alloc] initForAutoLayout];
        [self addSubview:self.contentContainer];
        [self.contentContainer autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.contentContainer autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                withInset:0];
        [self.contentContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                                withInset:0];
        
        self.hoursScroll = [[UIScrollView alloc] initForAutoLayout];
        self.hoursScroll.showsVerticalScrollIndicator = NO;
        self.hoursScroll.delegate = self;
        [self.contentContainer addSubview:self.hoursScroll];
        [self.hoursScroll autoSetDimension:ALDimensionWidth
                                    toSize:kScrollLineWidth];
        [self.hoursScroll autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                   excludingEdge:ALEdgeRight];
        
        UILabel *dotsLabel = [[UILabel alloc] initForAutoLayout];
        dotsLabel.text = @":";
        dotsLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                          size:16.];
        dotsLabel.textColor = [UIColor whiteColor];
        [self.contentContainer addSubview:dotsLabel];
        [dotsLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [dotsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight
                        ofView:self.hoursScroll];
        
        self.minutesScroll = [[UIScrollView alloc] initForAutoLayout];
        self.minutesScroll.showsVerticalScrollIndicator = NO;
        self.minutesScroll.delegate = self;
        [self.contentContainer addSubview:self.minutesScroll];
        [self.minutesScroll autoPinEdgeToSuperviewEdge:ALEdgeTop
                                             withInset:0];
        [self.minutesScroll autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                             withInset:0];
        [self.minutesScroll autoSetDimension:ALDimensionWidth
                                      toSize:kScrollLineWidth];
        [self.minutesScroll autoPinEdge:ALEdgeLeft
                                 toEdge:ALEdgeRight
                                 ofView:dotsLabel];
        
        self.periodScroll = [[UIScrollView alloc] initForAutoLayout];
        self.periodScroll.showsVerticalScrollIndicator = NO;
        self.periodScroll.delegate = self;
        [self.contentContainer addSubview:self.periodScroll];
        [self.periodScroll autoSetDimensionsToSize:CGSizeMake(kScrollLineWidth, kPeriodScrollHeight)];
        [self.periodScroll autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.periodScroll autoPinEdgeToSuperviewEdge:ALEdgeRight
                                            withInset:0];
        [self.periodScroll autoPinEdge:ALEdgeLeft
                                toEdge:ALEdgeRight
                                ofView:self.minutesScroll];
        
        UIView *topNonFocusOverlay = [[UIView alloc] initForAutoLayout];
        topNonFocusOverlay.backgroundColor = [UIColor colorFromHex:0x6a6ccf
                                                             alpha:70];
        UIView *bottomNonFocusOverlay = [[UIView alloc] initForAutoLayout];
        bottomNonFocusOverlay.backgroundColor = [UIColor colorFromHex:0x6a6ccf
                                                                alpha:70];
        [self addSubview:topNonFocusOverlay];
        [self addSubview:bottomNonFocusOverlay];
        
        [topNonFocusOverlay autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                     excludingEdge:ALEdgeBottom];
        [bottomNonFocusOverlay autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                        excludingEdge:ALEdgeTop];
        [topNonFocusOverlay autoPinEdge:ALEdgeBottom
                                 toEdge:ALEdgeTop
                                 ofView:focusLine];
        [bottomNonFocusOverlay autoPinEdge:ALEdgeTop
                                    toEdge:ALEdgeBottom
                                    ofView:focusLine];
        
        [self addHoursToBottom:YES];
        [self addMinutesToBottom:YES];
        [self buildPeriodLine];
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
}

- (NSString *)formattedNumber:(NSInteger)number
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.minimumIntegerDigits = 2;
    }
    return [formatter stringFromNumber:@(number)];
}

- (void)addItem:(UIView *)item
   toScrollView:(UIScrollView *)scrollView
       toLabels:(NSMutableArray *)labels
       toBottom:(BOOL)toBottom
{
    if (toBottom) {
        UIView *lastLabel = [labels lastObject];
        item.y = lastLabel.bottom;
        [labels addObject:item];
        [scrollView addSubview:item];
    } else {
        for (UIView *subview in labels) {
            subview.y += item.height;
        }
        scrollView.contentOffsetY += item.height;
        [labels insertObject:item atIndex:0];
        [scrollView insertSubview:item atIndex:0];
    }
    scrollView.contentSizeHeight = [labels.lastObject bottom];
}

- (void)addHoursToBottom:(BOOL)toBottom
{
    if (!_hoursLabels) {
        _hoursLabels = [NSMutableArray array];
    }
    NSInteger hours = 12;
    for (int i = 0; i < hours; i++) {
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScrollLineWidth, kScrollItemLabelHeight)];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        if (hours == 12 && i == 0) {
            hourLabel.text = [self formattedNumber:(toBottom ? 12 : (hours - 11))];
        } else {
            hourLabel.text = [self formattedNumber:(toBottom ? i : (hours - i - 1))];
        }
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                          size:16.];
        [self addItem:hourLabel
         toScrollView:self.hoursScroll
             toLabels:self.hoursLabels
             toBottom:toBottom];
    }
}


- (void)addMinutesToBottom:(BOOL)toBottom
{
    if (!_minutesLabels) {
        _minutesLabels = [NSMutableArray array];
    }
    NSInteger minutes = 60;
    for (int i = 0; i < minutes; i += 1) {
        UILabel *minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScrollLineWidth, kScrollItemLabelHeight)];
        minuteLabel.textAlignment = NSTextAlignmentCenter;
        minuteLabel.text = [self formattedNumber:(toBottom ? i : (minutes - i - 1))];
        minuteLabel.textColor = [UIColor whiteColor];
        minuteLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                            size:16.];
        [self addItem:minuteLabel
         toScrollView:self.minutesScroll
             toLabels:self.minutesLabels
             toBottom:toBottom];
    }
}

- (void)buildPeriodLine
{
    NSArray *periods = @[@"AM", @"PM"];
    for (int i = 0 ; i < periods.count ; i++) {
        NSString *period = periods[i];
        UILabel *periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                         kPeriodScrollHeight / 2 - kScrollItemLabelHeight/ 2 + kScrollItemLabelHeight * i,
                                                                         kScrollLineWidth,
                                                                         kScrollItemLabelHeight)];
        periodLabel.textAlignment = NSTextAlignmentCenter;
        periodLabel.text = period;
        periodLabel.textColor = [UIColor whiteColor];
        periodLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                            size:16.];
        [self.periodScroll addSubview:periodLabel];
    }
    self.periodScroll.contentSizeHeight = kPeriodScrollHeight + kScrollItemLabelHeight;
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
        NSDateComponents *components = _date.mt_components;
        components.minute = components.minute / 5 * 5 + 5;
        _date = [NSDate mt_dateFromComponents:components];
    }
    return _date;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSInteger hours = date.mt_hourOfDay;
    NSInteger hoursInDay = 12;
    if (hours > 11) {
        hours -= 12;
        self.periodScroll.contentOffsetY = kScrollItemLabelHeight;
    } else {
        self.periodScroll.contentOffsetY = 0;
    }
    NSInteger minutes = date.mt_minuteOfHour;
    CGSize pickerSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    // Workaround for some artefcats with new labels positioning when settings offset programmatically
    
    if (self.hoursLabels.count < hoursInDay * 3) {
        [self addHoursToBottom:YES];
        [self addHoursToBottom:NO];
    }
    if (self.minutesLabels.count < 60 * 3) {
        [self addMinutesToBottom:YES];
        [self addMinutesToBottom:NO];
    }
    // Increase label index to one iteration of content labels for
    // setting scroll offsset manually to some position in the middle
    NSInteger hoursLabelIdx = hoursInDay + hours;
    NSInteger minutesLabelIdx = minutes;
    CGFloat targetYOffsetHours = (hoursLabelIdx * kScrollItemLabelHeight) - pickerSize.height/2 + kScrollItemLabelHeight/2;
    CGFloat targetYOffsetMinutes = (minutesLabelIdx * kScrollItemLabelHeight) - pickerSize.height/2 + kScrollItemLabelHeight/2;
    self.hoursScroll.contentOffsetY = targetYOffsetHours;
    self.minutesScroll.contentOffsetY = targetYOffsetMinutes;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark = UIScrollViewDelegate methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffsetY < 0) {
        if (scrollView == self.hoursScroll) {
            [self addHoursToBottom:NO];
        }
        if (scrollView == self.minutesScroll) {
            [self addMinutesToBottom:NO];
        }
    }
    if (scrollView.contentOffsetY > scrollView.contentSizeHeight - scrollView.height) {
        if (scrollView == self.hoursScroll) {
            [self addHoursToBottom:YES];
        }
        if (scrollView == self.minutesScroll) {
            [self addMinutesToBottom:YES];
        }
    }
}

- (NSInteger)indexOfSelectedItemInScrollView:(UIScrollView *)scrollView
{
    CGSize pickerSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return (NSInteger)rintf((scrollView.contentOffsetY + pickerSize.height / 2 - kScrollItemLabelHeight / 2) / kScrollItemLabelHeight);
}

- (void)adjustContentOffsetInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.periodScroll) {
        CGFloat targetYOffset = rintf(scrollView.contentOffsetY / kScrollItemLabelHeight) * kScrollItemLabelHeight;
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffsetX, targetYOffset) animated:YES];
    } else {
        CGSize pickerSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSInteger subviewInFocusIdx = [self indexOfSelectedItemInScrollView:scrollView];
        CGFloat targetYOffset = (subviewInFocusIdx * kScrollItemLabelHeight) - pickerSize.height / 2 + kScrollItemLabelHeight / 2;
        CGPoint targetContentOffset = CGPointMake(scrollView.contentOffsetX, targetYOffset);
        [scrollView setContentOffset:targetContentOffset animated:YES];
    }
    [self updateSelectedDate];
}

- (void)updateSelectedDate
{
    NSInteger selectedHoursLabelIdx = [self indexOfSelectedItemInScrollView:self.hoursScroll];
    NSInteger selectedMinutesLabelIdx = [self indexOfSelectedItemInScrollView:self.minutesScroll];
    BOOL isAM = self.periodScroll.contentOffsetY < kScrollItemLabelHeight;
    NSInteger selectedHour = selectedHoursLabelIdx % 12;
    if (!isAM) {
        selectedHour += 12;
    }
    NSInteger selectedMinute = selectedMinutesLabelIdx % 60;
    _date = [NSDate mt_dateFromYear:0
                              month:0
                                day:0
                               hour:selectedHour
                             minute:selectedMinute];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustContentOffsetInScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self adjustContentOffsetInScrollView:scrollView];
    }
}

@end
