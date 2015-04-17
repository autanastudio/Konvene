//
//  KLEventListController.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListController.h"
#import "KLEventListDataSource.h"


@interface KLEventListController ()

@property (nonatomic, assign) KLEVEntListType type;

@end

@implementation KLEventListController

- (instancetype)initWithType:(KLEVEntListType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLEventListDataSource *dataSource = [[KLEventListDataSource alloc] init];
    return dataSource;
}

- (NSString *)title
{
    switch (self.type) {
        case KLEVEntListTypeGoing:
            return SFLocalized(@"event.myevent.going.title");
            break;
        case KLEVEntListTypeSaved:
            return SFLocalized(@"event.myevent.saved.title");
            break;
        default:
            return @"";
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



@end
