//
//  KLEventDataSource.h
//  Klike
//
//  Created by admin on 29/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFDataSource.h"
#import "KLEventPageCell.h"

typedef enum : NSUInteger {
    KLEventDataSourceSectionTypeData,
    KLEventDataSourceSectionTypeComments
} KLEventDataSourceSectionType;

@interface KLEventDataSource : SFDataSource

@property (nonatomic, strong) NSMutableArray *cells;

- (void)addItem:(KLEventPageCell *)input;

@end
