//
//  KLFormDataSource.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataSource.h"
#import "KLFormCell.h"

@class KLFormDataSource;

@protocol SFFormDataSourceDelegate <SFDataSourceDelegate>
- (void)dataSource:(KLFormDataSource *)dataSource didUpdateMetricsAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataSource:(KLFormDataSource *)dataSoucre didInsertRowsAtIndexPaths:(NSArray *)indexPaths;
- (void)dataSource:(KLFormDataSource *)dataSoucre didRemoveRowsAtIndexPaths:(NSArray *)indexPaths;
@end

@interface KLFormDataSource : SFDataSource

@property (nonatomic, weak) id<SFFormDataSourceDelegate> delegate;

- (void)insertForm:(KLFormCell *)input
           atIndex:(NSInteger)index;
- (void)updateFormsWithSuggestions:(NSDictionary *)dictionary;
- (void)addFormInput:(KLFormCell *)input;
- (void)becomeFirstResponder;
- (void)notifyTableRowSelecion:(NSIndexPath *)indexPath;

@end
