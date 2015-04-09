//
//  KLFormDataSource.m
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormDataSource.h"
#import "KLFormCell_Private.h"


@interface KLFormDataSource () <KLFormCellDelegate>

- (void)updateFormCellWithErrors:(NSDictionary *)errors;
- (void)handleFormErrors:(NSDictionary *)errors;

- (NSDictionary *)keyValueRepresention;

@end

@implementation KLFormDataSource

- (NSMutableArray *)formCells
{
    if (!_formCells) {
        _formCells = [NSMutableArray arrayWithCapacity:4];
    }
    return _formCells;
}

- (void)addFormInput:(KLFormCell *)input
{
    if (self.formCells.count > 0) {
        input.cellPosition = SFFormCellPositionLast;
        KLFormCell *lastCellOld = self.formCells.lastObject;
        if (self.formCells.count == 1) {
            lastCellOld.cellPosition = SFFormCellPositionFirst;
        }
        if (self.formCells.count > 1) {
            lastCellOld.cellPosition = SFFormCellPositionMiddle;
        }
    } else {
        input.cellPosition = SFFormCellPositionStandalone;
    }
    input.delegate = self;
    [self.formCells addObject:input];
}

- (NSDictionary *)keyValueRepresention
{
    NSMutableDictionary *formKeyValue = [NSMutableDictionary dictionary];
    [self.formCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *keyValueRepresentation = [(KLFormCell *)obj keyValueRepresentation];
        [formKeyValue addEntriesFromDictionary:keyValueRepresentation];
    }];
    return [formKeyValue copy];
}

- (void)becomeFirstResponder
{
    [self.formCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj canBecomeFirstResponder]) {
            [(KLFormCell *)obj becomeFirstResponder];
            (* stop) = YES;
        }
    }];
}

- (NSArray *)indexPathsForItem:(id)item
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [_formCells enumerateObjectsUsingBlock:^(id obj, NSUInteger objectIndex, BOOL *stop) {
        if ([obj isEqual:item])
            [indexPaths addObject:[NSIndexPath indexPathForRow:objectIndex inSection:0]];
    }];
    return indexPaths;
}

#pragma mark SFFormCellDelegate methods

- (void)formCellDidChangeValue:(KLFormCell *)cell
{
    NSTimeInterval delay = 3;
    if (self.formCells.lastObject == cell) {
        delay = 2;
    }
}

- (void)formCellDidCompleteInput:(KLFormCell *)cell
{
    
}

- (void)formCellDidUpdateContentSize:(KLFormCell *)cell
{
    NSInteger cellIndex = [self.formCells indexOfObject:cell];
    if ([self.delegate respondsToSelector:@selector(dataSource:didUpdateMetricsAtIndexPath:)]) {
        [self.delegate dataSource:self didUpdateMetricsAtIndexPath:[NSIndexPath indexPathForRow:cellIndex
                                                                                      inSection:0]];
    }
}

- (void)formCellDidSubmitInput:(KLFormCell *)cell
{
    NSInteger cellIndex = [self.formCells indexOfObject:cell] + 1;
    while (cellIndex < self.formCells.count) {
        KLFormCell *cell = self.formCells[cellIndex];
        if ([cell canBecomeFirstResponder]) {
            [cell becomeFirstResponder];
            return;
        }
        cellIndex++;
    }
    [cell resignFirstResponder];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.formCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.formCells[indexPath.row];
}

@end
