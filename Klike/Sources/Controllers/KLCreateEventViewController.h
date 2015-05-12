//
//  KLCreateEventViewController.h
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLListViewController.h"
#import "KLParalaxHeaderViewController.h"

typedef enum : NSUInteger {
    KLCreateEventViewControllerTypeCreate,
    KLCreateEventViewControllerTypeEdit
} KLCreateEventViewControllerType;

@class KLCreateEventHeaderView, KLCreateEventViewController;

@protocol KLCreateEventDelegate <NSObject>

- (void)dissmissCreateEventViewController:(KLCreateEventViewController *)controller
                                 newEvent:(KLEvent *)event;

@end

@interface KLCreateEventViewController : KLParalaxHeaderViewController

@property (nonatomic, weak) id<KLCreateEventDelegate> delegate;

- (instancetype)initWithType:(KLCreateEventViewControllerType)type
                       event:(KLEvent *)event;

@end
