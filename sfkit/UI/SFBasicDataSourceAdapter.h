//
//  SFBasicDataSourceDelegate.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 31/08/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFDataSource_Private.h"

@interface SFBasicDataSourceAdapter : NSObject <SFDataSourceDelegate>
@property (nonatomic, weak) id<SFDataSourceDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
