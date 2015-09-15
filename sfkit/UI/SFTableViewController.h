//
//  SFTablewViewController.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataSource_Private.h"

@interface SFTableViewController : UITableViewController
@property (nonatomic, strong) id<SFDataSourceDelegate> dataSourceDelegate;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate NS_REQUIRES_SUPER;

/**
 Basic implementation tell SFDataSource that it should load next page.
 */
- (void)didReachEndOfList;

- (void)onRefreshContent;

@end
