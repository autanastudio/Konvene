//
//  KLEventLoadingPageCell.m
//  Klike
//
//  Created by Katekov Anton on 20.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventLoadingPageCell.h"
#import "KLActivityIndicator.h"



@implementation KLEventLoadingPageCell

- (void)build
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [view autoSetDimension:ALDimensionHeight toSize:60];
    
    KLActivityIndicator *indicator = [KLActivityIndicator colorIndicator];
    [view addSubview:indicator];
    [indicator autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [indicator autoCenterInSuperview];
    [indicator setAnimating:YES];
}

@end
