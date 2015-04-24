//
//  KLTableView.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTableView.h"

@implementation KLTableView

- (void)dealloc
{
    [self sf_removeAllObservers];
}

- (void)setRefreshControl:(SFRefreshControl *)refreshControl
{
    [self addSubview:refreshControl];
    _refreshControl = refreshControl;
}

@end
