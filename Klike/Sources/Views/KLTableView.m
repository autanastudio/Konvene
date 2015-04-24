//
//  KLTableView.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTableView.h"

@interface KLTableView ()
@property (nonatomic, weak) SFRefreshControl *refreshControl;
@end

@implementation KLTableView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.refreshControl.shouldAdjustForPinnedHeader) {
        UIView *header = self.tableHeaderView;
        NSInteger headerIdx = [self.subviews indexOfObject:header];
        NSInteger refreshIdx = [self.subviews indexOfObject:self.refreshControl];
        if (headerIdx > refreshIdx) {
            [self exchangeSubviewAtIndex:headerIdx withSubviewAtIndex:refreshIdx];
        }
    }
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if ([subview isKindOfClass:[SFRefreshControl class]]) {
        self.refreshControl = (SFRefreshControl *)subview;
    }
}

- (void)dealloc
{
    [self sf_removeAllObservers];
    self.refreshControl = nil;
}

@end
