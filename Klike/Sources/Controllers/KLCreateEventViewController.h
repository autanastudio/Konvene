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

@class KLCreateEventHeaderView;

@protocol KLCreateEventDelegate <NSObject>

- (void)dissmissCreateEventViewController;

@end

@interface KLCreateEventViewController : KLParalaxHeaderViewController

@property (nonatomic, weak) id<KLCreateEventDelegate> delegate;

@end
