//
//  SFSingleCellDataSource.h
//  Livid
//
//  Created by Yarik Smirnov on 2/4/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFDataSource.h"

@interface SFSingleCellDataSource : SFDataSource

- (instancetype)initWithCell:(UITableViewCell *)cell;

@end
