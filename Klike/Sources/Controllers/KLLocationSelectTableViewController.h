//
//  KLLocationSelectTableViewController.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLLocationDataSource.h"

@class KLLocationSelectTableViewController, KLForsquareVenue;

@protocol KLLocationSelectTableViewControllerDelegate <NSObject>

- (void)dissmissLocationSelectTableView:(KLLocationSelectTableViewController *)selectViewController
                              withVenue:(KLForsquareVenue *)venue;

@end

@interface KLLocationSelectTableViewController : UITableViewController

@property (nonatomic, weak) id<KLLocationSelectTableViewControllerDelegate> delegate;
@property (nonatomic, weak) id<KLChildrenViewControllerDelegate> kl_parentViewController;

- (instancetype)initWithType:(KLLocationSelectType)type;

@end
