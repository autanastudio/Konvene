
//
//  SFBasicDataSourceDelegate.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 31/08/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFBasicDataSourceAdapter.h"

@interface SFBasicDataSourceAdapter ()
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation SFBasicDataSourceAdapter {
    NSMutableIndexSet        *_batchRefreschSections;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds)
        responds = [[self forwardingTargetForSelector:aSelector] respondsToSelector:aSelector];
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.delegate;
}

#pragma mark - SFDataSourceDelegate methods

- (void)dataSource:(SFDataSource *)dataSource
    didInsertItemsAtIndexPaths:(NSArray *)indexPaths
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didInsertItemsAtIndexPaths:indexPaths direction:direction];
    } else {
        UITableViewRowAnimation animation = UITableViewRowAnimationNone;
        if (direction == SFDataSourceSectionOperationDirectionLeft) {
            animation = UITableViewRowAnimationLeft;
        } else if (direction == SFDataSourceSectionOperationDirectionRight) {
            animation = UITableViewRowAnimationRight;
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
    didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
        direction:(SFDataSourceSectionOperationDirection)direction
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didRemoveItemsAtIndexPaths:indexPaths direction:direction];
    } else {
        UITableViewRowAnimation animation = UITableViewRowAnimationNone;
        if (direction == SFDataSourceSectionOperationDirectionLeft) {
            animation = UITableViewRowAnimationRight;
        } else if (direction == SFDataSourceSectionOperationDirectionRight) {
            animation = UITableViewRowAnimationLeft;
        }
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
    didRefreshItemsAtIndexPaths:(NSArray *)indexPaths
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didRefreshItemsAtIndexPaths:indexPaths direction:direction];
    } else {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
    didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath
       toIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didMoveItemAtIndexPath:fromIndexPath toIndexPath:newIndexPath];
    } else {
        [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:newIndexPath];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
 didRemoveSections:(NSIndexSet *)sections
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didRemoveSections:sections direction:direction];
    } else {
        UITableViewRowAnimation animation = UITableViewRowAnimationNone;
        if (direction == SFDataSourceSectionOperationDirectionLeft) {
            animation = UITableViewRowAnimationRight;
        } else if (direction == SFDataSourceSectionOperationDirectionRight) {
            animation = UITableViewRowAnimationLeft;
        }
        [self.tableView deleteSections:sections withRowAnimation:animation];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
 didInsertSections:(NSIndexSet *)sections
         direction:(SFDataSourceSectionOperationDirection)direction
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didInsertSections:sections direction:direction];
    } else {
        UITableViewRowAnimation animation = UITableViewRowAnimationNone;
        if (direction == SFDataSourceSectionOperationDirectionLeft) {
            animation = UITableViewRowAnimationLeft;
        } else if (direction == SFDataSourceSectionOperationDirectionRight) {
            animation = UITableViewRowAnimationRight;
        }
        [self.tableView insertSections:sections withRowAnimation:animation];
    }
}

- (void)dataSource:(SFDataSource *)dataSource didRefreshSections:(NSIndexSet *)sections
{
    NSMutableIndexSet *sectionsToReload = sections.mutableCopy;
    [sectionsToReload removeIndexes:_batchRefreschSections];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource didRefreshSections:sectionsToReload];
    } else {
        if (sectionsToReload.count > 0) {
            [UIView performWithoutAnimation:^{
                [self.tableView reloadSections:sectionsToReload withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }
    [_batchRefreschSections addIndexes:sections];
}

- (void)dataSourceDidReloadData:(SFDataSource *)dataSource
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSourceDidReloadData:dataSource];
    } else {
        [self.tableView reloadData];
    }
}

- (void)dataSource:(SFDataSource *)dataSource
performBatchUpdate:(dispatch_block_t)update
          complete:(dispatch_block_t)complete
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate dataSource:dataSource performBatchUpdate:update complete:complete];
    } else {
        _batchRefreschSections = [NSMutableIndexSet indexSet];
        [UIView performWithoutAnimation:^{
            [self.tableView beginUpdates];
            if (update) {
                update();
            }
            [self.tableView endUpdates];
        }];
        _batchRefreschSections = nil;
        if (complete) {
            complete();
        }
    }
}


@end
