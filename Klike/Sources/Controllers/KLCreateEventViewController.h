//
//  KLCreateEventViewController.h
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLListViewController.h"

@class KLCreateEventHeaderView;

@protocol KLCreateEventDelegate <NSObject>

- (void)dissmissCreateEventViewController;

@end

@interface KLCreateEventViewController : KLListViewController

@property (nonatomic, strong) KLCreateEventHeaderView *header;
@property (nonatomic, weak) id<KLCreateEventDelegate> delegate;

@end
