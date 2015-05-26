//
//  KLEventViewController.h
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLParalaxHeaderViewController.h"

@interface KLEventViewController : KLParalaxHeaderViewController {
    BOOL _needActionFinishedCell;
    BOOL _paymentState;
    BOOL _dataBuilded;

    UIActivityViewController *_activityViewController;
}

@property (nonatomic) KLEvent *event;
@property (nonatomic) BOOL needCloseButton;

@property (nonatomic) BOOL animated;
@property (nonatomic) UIImage *appScreenshot;
@property (nonatomic) CGPoint animationOffset;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
