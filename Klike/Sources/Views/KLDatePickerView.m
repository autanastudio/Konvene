//
//  KLDatePickerView.m
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLDatePickerView.h"

static const CGFloat kScrollItemLabelHeight = 48.0;
static const CGFloat kScrollLineWidth = 50.0;
static const CGFloat kScrollDayWidth = 100.0;
static const CGFloat kPeriodScrollHeight = 1000;

@interface KLDatePickerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *dayScroll;
@property (nonatomic, strong) UIScrollView *hoursScroll;
@property (nonatomic, strong) UIScrollView *minutesScroll;
@property (nonatomic, strong) UIScrollView *periodScroll;
@property (nonatomic, strong) UIView *contentContainer;

@property (nonatomic, strong) NSMutableArray *hoursLabels;
@property (nonatomic, strong) NSMutableArray *minutesLabels;
@property (nonatomic, strong) NSMutableArray *dayLabels;
@end

@implementation KLDatePickerView
@synthesize date = _date;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        
        _minimalDate = [NSDate date];
        
        self.backgroundColor = [UIColor colorFromHex:0x5253b5];
        
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
        [self.contentContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.dayScroll = [[UIScrollView alloc] initForAutoLayout];
        self.dayScroll.showsVerticalScrollIndicator = NO;
        self.dayScroll.clipsToBounds = NO;
        self.dayScroll.delegate = self;
        [self.contentContainer addSubview:self.dayScroll];
        [self.dayScroll autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                 excludingEdge:ALEdgeRight];
        
        self.hoursScroll = [[UIScrollView alloc] initForAutoLayout];
        self.hoursScroll.showsVerticalScrollIndicator = NO;
        self.hoursScroll.delegate = self;
        [self.contentContainer addSubview:self.hoursScroll];
        [self.hoursScroll autoSetDimension:ALDimensionWidth
                                    toSize:kScrollLineWidth];
        [self.hoursScroll autoPinEdgeToSuperviewEdge:ALEdgeTop
                                             withInset:0];
        [self.hoursScroll autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                           withInset:0];
        [self.hoursScroll autoPinEdge:ALEdgeLeft
                               toEdge:ALEdgeRight
                               ofView:self.dayScroll
                           withOffset:0.];
        
        UILabel *dotsLabel = [[UILabel alloc] initForAutoLayout];
        dotsLabel.text = @":";
        dotsLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                          size:16.];
        dotsLabel.textColor = [UIColor whiteColor];
        [self.contentContainer addSubview:dotsLabel];
        [dotsLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [dotsLabel autoAlignAxis:ALAxisVertical
                toSameAxisOfView:self.contentContainer
                      withOffset:31.];
        [dotsLabel autoPinEdge:ALEdgeLeft
                        toEdge:ALEdgeRight
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
                                 toEdge:ALEdgeLeft
                                 ofView:dotsLabel];
        
        self.periodScroll = [[UIScrollView alloc] initForAutoLayout];
        self.periodScroll.showsVerticalScrollIndicator = NO;
        self.periodScroll.delegate = self;
        [self.contentContainer addSubview:self.periodScroll];
        [self.periodScroll autoSetDimension:ALDimensionHeight
                                     toSize:kPeriodScrollHeight];
        [self.periodScroll autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.periodScroll autoPinEdge:ALEdgeLeft
                                toEdge:ALEdgeRight
                                ofView:self.minutesScroll
                            withOffset:0.];
        [self.periodScroll autoPinEdgeToSuperviewEdge:ALEdgeRight
                                            withInset:0.];
        
        UIView *topNonFocusOverlay = [[UIView alloc] initForAutoLayout];
        topNonFocusOverlay.userInteractionEnabled = NO;
        topNonFocusOverlay.backgroundColor = [UIColor colorFromHex:0x6a6ccf
                                                             alpha:70];
        UIView *bottomNonFocusOverlay = [[UIView alloc] initForAutoLayout];
        bottomNonFocusOverlay.userInteractionEnabled = NO;
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
        
        [self addDaysToBottom];
        [self addHoursToBottom:YES];
        [self addMinutesToBottom:YES];
        [self buildPeriodLine];
        
        [self.dayScroll setContentInsetTop:kScrollItemLabelHeight*2.];
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

- (void)addDaysToBottom
{
    if (!_dayLabels) {
        _dayLabels = [NSMutableArray array];
    }
    NSInteger days = 60;
    NSDate *day = self.minimalDate;
    for (int i = 0; i < days; i += 1) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScrollDayWidth, kScrollItemLabelHeight)];
        dayLabel.textAlignment = NSTextAlignmentRight;
        if (i==0 && [day mt_daysSinceDate:[NSDate date]]==0) {
            dayLabel.text = @"Today";
        } else {
            dayLabel.text = [day mt_stringFromDateWithFormat:@"EEE MMM d"
                                                   localized:NO];
        }
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                            size:16.];
        [self addItem:dayLabel
         toScrollView:self.dayScroll
             toLabels:self.dayLabels
             toBottom:YES];
        day = [day mt_oneDayNext];
    }
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
        UILabel *periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.,
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

- (void)setMinimalDate:(NSDate *)minimalDate
{
    if (![_minimalDate isEqualToDate:minimalDate]) {
        _minimalDate = minimalDate;
        [self.dayScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.dayLabels = nil;
        [self addDaysToBottom];
        if ([self.date mt_isBefore:_minimalDate]) {
            self.date = self.minimalDate;
        }
    }
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
    NSInteger days = [date mt_daysSinceDate:self.minimalDate];
    // Increase label index to one iteration of content labels for
    // setting scroll offsset manually to some position in the middle
    NSInteger hoursLabelIdx = hoursInDay + hours;
    NSInteger minutesLabelIdx = minutes;
    NSInteger daysIdx = days;
    CGFloat targetYOffsetHours = (hoursLabelIdx * kScrollItemLabelHeight) - pickerSize.height/2 + kScrollItemLabelHeight/2;
    CGFloat targetYOffsetMinutes = (minutesLabelIdx * kScrollItemLabelHeight) - pickerSize.height/2 + kScrollItemLabelHeight/2;
    CGFloat targetYOffsetDays = (daysIdx * kScrollItemLabelHeight) - pickerSize.height/2 + kScrollItemLabelHeight/2;
    self.hoursScroll.contentOffsetY = targetYOffsetHours;
    self.minutesScroll.contentOffsetY = targetYOffsetMinutes;
    self.dayScroll.contentOffsetY = targetYOffsetDays;
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
    NSInteger selectedDayIdx = [self indexOfSelectedItemInScrollView:self.dayScroll] + 2;
    BOOL isAM = self.periodScroll.contentOffsetY < kScrollItemLabelHeight;
    NSInteger selectedHour = selectedHoursLabelIdx % 12;
    if (!isAM) {
        selectedHour += 12;
    }
    NSInteger selectedMinute = selectedMinutesLabelIdx % 60;
    
    NSDateComponents *dateCompomemts = [self.minimalDate mt_dateDaysAfter:selectedDayIdx-2].mt_components;
    _date = [NSDate mt_dateFromYear:dateCompomemts.year
                              month:dateCompomemts.month
                                day:dateCompomemts.day
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
