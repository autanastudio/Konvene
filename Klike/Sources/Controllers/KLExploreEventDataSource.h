//
//  KLExploreEventDataSource.h
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPagedDataSource.h"

@class KLExploreEventDataSource;

@protocol KLExploreEventDataSourceDelegate <NSObject>
- (void)exploreEventDataSource:(KLExploreEventDataSource *)dataSource
         showAttendiesForEvent:(KLEvent *)event;
@end

@interface KLExploreEventDataSource : KLPagedDataSource

@property(nonatomic, weak) id<KLExploreEventDataSourceDelegate> listDelegate;

@end
