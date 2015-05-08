//
//  KLStaticDataSource.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLStaticDataSource.h"

@implementation KLStaticDataSource

- (NSMutableArray *)cells
{
    if (!_cells) {
        _cells = [NSMutableArray arrayWithCapacity:4];
    }
    return _cells;
}

- (void)addItem:(id)input
{
    [self.cells addObject:input];
}

- (NSArray *)indexPathsForItem:(id)item
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [_cells enumerateObjectsUsingBlock:^(id obj, NSUInteger objectIndex, BOOL *stop) {
        if ([obj isEqual:item])
            [indexPaths addObject:[NSIndexPath indexPathForRow:objectIndex inSection:0]];
    }];
    return indexPaths;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.row];
}

@end
