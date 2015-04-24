//
//  KLTableView.h
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshControl.h"

@interface KLTableView : UITableView

@property (nonatomic, strong) SFRefreshControl *refreshControl;

@end
