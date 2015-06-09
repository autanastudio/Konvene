//
//  KLActivitiesDataSource.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPagedDataSource.h"

@protocol KLActivitiesDataSourceDelegate <NSObject>

- (void)showUserProfile:(KLUserWrapper *)user;

@end

@interface KLActivitiesDataSource : KLPagedDataSource

@property (nonatomic, weak) id<KLActivitiesDataSourceDelegate> listDelegate;

@end
