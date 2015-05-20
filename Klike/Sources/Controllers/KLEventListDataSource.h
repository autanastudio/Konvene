//
//  KLEventListDataSource.h
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPagedDataSource.h"

@class KLEventListDataSource;

typedef enum : NSUInteger {
    KLEventListDataSourceTypeCreated,
    KLEventListDataSourceTypeGoing,
    KLEventListDataSourceTypeSaved,
} KLEventListDataSourceType;

@protocol KLEventListDataSourceDelegate <NSObject>
- (void)eventListDataSource:(KLEventListDataSource *)dataSource
      showAttendiesForEvent:(KLEvent *)event;
@end

@interface KLEventListDataSource : KLPagedDataSource

@property (nonatomic, assign) KLEventListDataSourceType type;
@property (nonatomic, strong) KLUserWrapper *user;
@property (nonatomic, weak) id<KLEventListDataSourceDelegate> listDelegate;

- (instancetype)initWithUser:(KLUserWrapper *)user
                        type:(KLEventListDataSourceType)type;

@end
