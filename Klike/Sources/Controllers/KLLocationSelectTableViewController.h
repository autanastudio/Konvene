//
//  KLLocationSelectTableViewController.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLLocationSelectTableViewController, KLForsquareVenue;

@protocol KLLocationSelectTableViewControllerDelegate <NSObject>

- (void)dissmissLocationSelectTableView:(KLLocationSelectTableViewController *)selectViewController
                              withVenue:(KLForsquareVenue *)venue;

@end

@interface KLLocationSelectTableViewController : UITableViewController

@property (nonatomic, strong) id<KLLocationSelectTableViewControllerDelegate> delegate;
@property (nonatomic, assign) id<KLChildrenViewControllerDelegate> kl_parentViewController;

@end
