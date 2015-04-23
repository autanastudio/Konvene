//
//  QDRefreshControl.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 22/09/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFRefreshControl.h"
#import "KLActivityIndicator.h"

@interface SFRefreshControl ()
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *images;
@property(nonatomic, assign) UIEdgeInsets initialInsets;

@property (nonatomic, strong) NSLayoutConstraint *horizontalConstraint;
@property (nonatomic, strong) NSLayoutConstraint *verticalConstraint;
@end

@implementation SFRefreshControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 0, 64);
    }
    return self;
}

- (void)setActivityIndicator:(KLActivityIndicator *)activityIndicator
{
    if (_activityIndicator) {
        [_activityIndicator removeFromSuperview];
    }
    _activityIndicator = activityIndicator;
    [self addSubview:self.activityIndicator];
    self.verticalConstraint = [self.activityIndicator autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.horizontalConstraint = [self.activityIndicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)dealloc {
    [self.scrollView sf_removeAllObservers];
}

- (void)setAlignment:(SFRefreshControlAligment)alignment
{
    _alignment = alignment;
    [self validateUpdateViewFrame];
}

- (void)setShouldAdjustForPinnedHeader:(BOOL)shouldAdjustForPinnedHeader
{
    _shouldAdjustForPinnedHeader = shouldAdjustForPinnedHeader;
    self.backgroundColor = [UIColor clearColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == self.scrollView) {
        return;
    }
    if (!newSuperview) {
        [self.scrollView sf_removeAllObservers];
        self.scrollView = nil;
    }
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *) newSuperview;
        [self validateUpdateViewFrame];

        __weak typeof(self) weakSelf = self;
        [self.scrollView sf_addObserverForKeyPath:sf_key(contentOffset)
                                        withBlock:^(id obj, NSDictionary *change, id observer) {
                                            [weakSelf scrollViewDidScroll:weakSelf.scrollView];
                                        }];
        [self.scrollView sf_addObserverForKeyPath:sf_key(contentSize)
                                        withBlock:^(id obj, NSDictionary *change, id observer) {
                                            [weakSelf validateUpdateViewFrame];
                                        }];
        [self.scrollView sf_addObserverForKeyPath:sf_key(bounds)
                                        withBlock:^(id obj, NSDictionary *change, id observer) {
                                            [weakSelf validateUpdateViewFrame];
                                        }];
    }
}

- (CGFloat)convertYOffsetToAbsOffset:(CGFloat)yOffset {
    yOffset += self.scrollView.contentInsetTop;
    if (self.alignment == SFRefreshControlAlignmentTop) {
        return fabsf(MIN(yOffset, 0));
    }
    if (yOffset < 0) {
        return 0;
    }
    CGFloat diff = self.scrollView.contentSizeHeight - self.scrollView.height + self.scrollView.contentInsetBottom;
    if (diff < 0) {
        return fabsf(yOffset);
    }
    return MAX(0, yOffset - diff);
}

- (void)validateUpdateViewFrame {
    if (self.alignment == SFRefreshControlAlignmentTop) {
        self.frame = CGRectMake(0, -self.height, self.scrollView.width, self.height);
        if (self.shouldAdjustForPinnedHeader) {
            self.y = - self.height - 64;//Pinned Header goes under transparent background;
            self.horizontalConstraint.constant = 10;
        }
    } else {
        self.frame = CGRectMake(0,
                                MAX(self.scrollView.contentSizeHeight,
                                    self.scrollView.height - self.scrollView.contentInsetTop),
                                self.scrollView.width,
                                self.height);
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (UIEdgeInsets)updatingInsets {
    UIEdgeInsets insets = self.scrollView.contentInset;

    if (self.alignment == SFRefreshControlAlignmentTop) {
        insets.top += self.frame.size.height;
    } else {
        insets.bottom += self.frame.size.height;
        if (self.scrollView.contentSizeHeight < self.scrollView.height) {
            insets.bottom += self.scrollView.height - self.scrollView.contentSizeHeight - self.scrollView.contentInsetTop;
        }
    }
    return insets;
}

- (void)endUpdating {
    if (!self.refreshing) {
        return;
    }
    self.refreshing = NO;
    self.activityIndicator.animating = NO;
    UIScrollView *scroll = self.scrollView;
    UITableView *tv = nil;
    NSIndexPath *lastIndex = nil;
    if ([scroll isKindOfClass:[UITableView class]] && self.alignment == SFRefreshControlAlignmentBottom) {
        tv = (UITableView *)scroll;
        NSInteger numberOfSections = tv.numberOfSections;
        NSInteger numberOfRows = [tv numberOfRowsInSection:numberOfSections - 1];
        lastIndex = [NSIndexPath indexPathForRow:numberOfRows - 1
                                       inSection:numberOfSections - 1];
        CGRect cellRect = [tv rectForRowAtIndexPath:lastIndex];
        CGFloat contentBottom = MAX(tv.height, cellRect.origin.y + cellRect.size.height);
        CGFloat  offsetY = contentBottom - tv.height + self.initialInsets.bottom;
        tv.contentOffset = CGPointMake(0, offsetY + self.height);
    }
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         scroll.contentInset = self.initialInsets;
                         if (tv != nil && self.alignment == SFRefreshControlAlignmentBottom) {
                             //Just in case it has changed, because of self-sizing cells autolayout issues
                             CGRect cellRect = [tv rectForRowAtIndexPath:lastIndex];
                             CGFloat contentBottom = MAX(tv.height, cellRect.origin.y + cellRect.size.height);
                             CGFloat  offsetY = contentBottom - tv.height + self.initialInsets.bottom;
                             tv.contentOffset = CGPointMake(0, offsetY);
                         }
                         [self.scrollView layoutIfNeeded];
                     } completion:^(BOOL finished) {
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = [self convertYOffsetToAbsOffset:scrollView.contentOffsetY];
    if (offset > 0 && !self.activityIndicator.animating) {
        if (offset > 150) {
            self.activityIndicator.animating = YES;
        } else if ((NSInteger)offset % (NSInteger)rintf((float)150 / (float)self.activityIndicator.stepCount) == 0) {
            //Step activityIndicator frame every equal length before it starts animating indefinitely
            [self.activityIndicator stepAnimation];
        }
    }
}

- (void)didRelease {
    CGFloat offset = [self convertYOffsetToAbsOffset:self.scrollView.contentOffsetY];
    if (offset == 0) {
        return;
    }
    if ((self.activityIndicator.animating || offset > 60) && !self.refreshing) {
        self.refreshing = YES;
        self.activityIndicator.animating = YES;
        self.initialInsets = self.scrollView.contentInset;
        CGPoint contentOffset = self.scrollView.contentOffset;
        [UIView animateWithDuration:.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                               self.scrollView.contentInset = [self updatingInsets];
                               self.scrollView.contentOffset = contentOffset;
                           }
                              completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        });
    }
}

@end
