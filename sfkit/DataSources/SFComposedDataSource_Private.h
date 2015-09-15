//
//  SFComposedDataSource_Private.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"

#import "SFComposedDataSource.h"

@class SFDataSource;

/// Maps global sections to local sections for a given data source
@interface SFComposedMapping : NSObject <NSCopying>

- (instancetype)initWithDataSource:(SFDataSource *)dataSource;

/// The data source associated with this mapping
@property (nonatomic, strong) SFDataSource * dataSource;

/// The number of sections in this mapping
@property (nonatomic, readonly) NSInteger sectionCount;

/// Return the local section for a global section
- (NSUInteger)localSectionForGlobalSection:(NSUInteger)globalSection;

/// Return the global section for a local section
- (NSUInteger)globalSectionForLocalSection:(NSUInteger)localSection;

/// Return a local index path for a global index path
- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath;

/// Return a global index path for a local index path
- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath;

/// Return an array of local index paths from an array of global index paths
- (NSArray *)localIndexPathsForGlobalIndexPaths:(NSArray *)globalIndexPaths;

/// Return an array of global index paths from an array of local index paths
- (NSArray *)globalIndexPathsForLocalIndexPaths:(NSArray *)localIndexPaths;

/// Update the mapping of local sections to global sections.
- (NSUInteger)updateMappingsStartingWithGlobalSection:(NSUInteger)globalSection;

@end

/// An object that pretends to be either a UITableView or UICollectionView that handles transparently mapping from local to global index paths
@interface SFComposedViewWrapper : NSObject

+ (id)wrapperForView:(UIView *)view mapping:(SFComposedMapping *)mapping;

@property (nonatomic, retain) UIView *wrappedView;
@property (nonatomic, retain) SFComposedMapping *mapping;

@end