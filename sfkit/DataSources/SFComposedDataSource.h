//
//  SFComposedDataSource.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"

@interface SFComposedDataSource : SFDataSource

/// Add a data source to the data source.
- (void)addDataSource:(SFDataSource *)dataSource;

/// Remove the specified data source from this data source.
- (void)removeDataSource:(SFDataSource *)dataSource;

- (SFDataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex;

@end
