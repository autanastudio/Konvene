//
//  SFSingleCellDataSource.m
//  Livid
//
//  Created by Yarik Smirnov on 2/4/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFSingleCellDataSource.h"

@interface SFSingleCellDataSource ()
@property (nonatomic, strong) UITableViewCell *cell;
@end

@implementation SFSingleCellDataSource

-(instancetype)initWithCell:(UITableViewCell *)cell
{
    self = [super init];
    if (self) {
        _cell = cell;
        self.loadingState = SFLoadStateLoadingContent;
        self.loadingState = SFLoadStateContentLoaded;
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell;
}

@end
