//
//  KLStaticDataSource.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFDataSource.h"

@interface KLStaticDataSource : SFDataSource

@property (nonatomic, strong) NSMutableArray *cells;

- (void)addItem:(id)input;

@end
