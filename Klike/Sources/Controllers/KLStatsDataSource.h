//
//  KLStatsDataSource.h
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFBasicDataSource.h"

@interface KLStatsDataSource : SFBasicDataSource

@property (nonatomic, assign) BOOL sortByAmount;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
