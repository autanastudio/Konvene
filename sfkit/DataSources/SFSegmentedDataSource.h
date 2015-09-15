//
//  SFSegmentedDataSource.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFDataSource.h"

@protocol ISFSegmentedControl <NSObject>
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) BOOL userInteractionEnabled;

- (void)removeAllSegments;
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end

@interface UISegmentedControl (SFDataSourceAddition) <ISFSegmentedControl>
@end

@interface SFSegmentedDataSource : SFDataSource {
@protected
    SFDataSource *_selectedDataSource;
}

/// Add a data source to the end of the collection. The title property of the data source will be used to populate a new segment in the UISegmentedControl associated with this data source.
- (void)addDataSource:(SFDataSource *)dataSource;

/// Remove the data source from the collection.
- (void)removeDataSource:(SFDataSource *)dataSource;

- (void)insertDataSource:(SFDataSource *)dataSource atIndex:(NSInteger)index;

/// Clear the collection of data sources.
- (void)removeAllDataSources;

/// The collection of data sources contained within this segmented data source.
@property (nonatomic, readonly) NSArray *dataSources;


/// A reference to the selected data source.
@property (nonatomic, strong) SFDataSource *selectedDataSource;

@property (nonatomic, assign) BOOL animateDataSourceSelection; //Default is NO.

/// The index of the selected data source in the collection.
@property (nonatomic) NSInteger selectedDataSourceIndex;

/// Set the selected data source with animation. By default, setting the selected data source is not animated.
- (void)setSelectedDataSource:(SFDataSource *)selectedDataSource animated:(BOOL)animated;

/// Set the index of the selected data source with optional animation. By default, setting the selected data source index is not animated.
- (void)setSelectedDataSourceIndex:(NSInteger)selectedDataSourceIndex animated:(BOOL)animated;

/// Call this method to configure a segmented control with the titles of the data sources. This method also sets the target & action of the segmented control to switch the selected data source. Should be called after all data sources was added.
- (void)configureSegmentedControl:(id<ISFSegmentedControl>)segmentedControl;


@end
