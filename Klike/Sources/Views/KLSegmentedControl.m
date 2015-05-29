//
//  KLSegmentedControl.m
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSegmentedControl.h"

static NSTimeInterval klSegmentControlAnimationDuration = 0.15;
static CGFloat klSegmentControlDefaultIndicatorHeight = 3.;

@interface KLSegmentedControl ()

@property (nonatomic, strong) UIView *indicator;

@end

@implementation KLSegmentedControl

+ (KLSegmentedControl *)kl_segmentedControl
{
    KLSegmentedControl *segmentedControl = [[KLSegmentedControl alloc] init];
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.tintColor = [UIColor clearColor];
    [segmentedControl setBackgroundImage:[UIImage new]
                                forState:UIControlStateNormal
                              barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage new]
                  forLeftSegmentState:UIControlStateNormal
                    rightSegmentState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHex:0x6d6d81],
                                               NSFontAttributeName : [UIFont helveticaNeue:SFFontStyleMedium size:14.]}
                                    forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHex:0x6465c6],
                                               NSFontAttributeName : [UIFont helveticaNeue:SFFontStyleMedium size:14.]}
                                    forState:UIControlStateSelected];
    segmentedControl.indicatorColor = [UIColor colorFromHex:0x6465c6];
    return segmentedControl;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.indicatorHeight = klSegmentControlDefaultIndicatorHeight;
    self.indicator = [[UIView alloc] init];
    self.indicator.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicator];
    [self addTarget:self
             action:@selector(changeSelectedIndex)
   forControlEvents:UIControlEventValueChanged];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithTitle:title atIndex:segment animated:animated];
    [self updateIndicatorFrameAnimated:animated];
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    _indicatorHeight = indicatorHeight;
    [self updateIndicatorFrameAnimated:NO];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicator.backgroundColor = indicatorColor;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    [self updateIndicatorFrameAnimated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateIndicatorFrameAnimated:NO];
}

- (void)changeSelectedIndex
{
    [self updateIndicatorFrameAnimated:YES];
}

- (void)updateIndicatorFrameAnimated:(BOOL)animated
{
    CGFloat contorlHeight = self.frame.size.height;
    CGFloat indicatorWidth = self.frame.size.width/self.numberOfSegments;
    
    CGRect newFrame = CGRectMake(indicatorWidth*self.selectedSegmentIndex,
                                 contorlHeight-self.indicatorHeight,
                                 indicatorWidth,
                                 self.indicatorHeight);
    if (animated) {
        [UIView animateWithDuration:klSegmentControlAnimationDuration
                         animations:^{
            self.indicator.frame = newFrame;
        }];
    } else {
        self.indicator.frame = newFrame;
    }
}

- (void)setContentOffset:(CGSize)offset
{
    for (int i =0; i<self.numberOfSegments; i++) {
        [self setContentOffset:offset
             forSegmentAtIndex:i];
    }
}

@end
