//
//  KLListViewController.h
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshControl.h"

@interface KLListViewController : KLViewController <SFDataSourceDelegate, UITableViewDelegate>

@property (nonatomic, strong) SFRefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFBasicDataSourceAdapter *dataSourceAdapter;
@property (nonatomic, strong) SFDataSource *dataSource;
@property (nonatomic, assign) CGFloat contentInsetBottom;

- (void)refreshList;
- (void)didReachEndOfList;
- (SFDataSource *)buildDataSource;
- (void)addRefrshControlWithActivityIndicator:(KLActivityIndicator *)activityIndicator;

@end
