//
//  KLExplorePeopleDataSource.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleDataSource.h"
#import "KLExplorePeopleCell.h"
#import "KLExplorePeopleTopCell.h"
#import "KLPlaceholderCell.h"

static NSString *klCellReuseId = @"ExplorePeopleCell";
static NSString *klEventListTopUserCell = @"ExplorePeopleTopCell";

@implementation KLExplorePeopleDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.phoneNumbers = nil;
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:nil
                                                                  image:nil
                                                            buttonTitle:nil
                                                           buttonAction:nil];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCellReuseId];
    [tableView registerNib:[UINib nibWithNibName:klEventListTopUserCell
                                          bundle:nil]
    forCellReuseIdentifier:klEventListTopUserCell];
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query includeKey:sf_key(location)];
    if (self.phoneNumbers) {
        [query whereKey:sf_key(phoneNumber)
         notContainedIn:self.phoneNumbers];
    }
    NSArray *excludingIds = [KLAccountManager sharedManager].currentUser.following;
    excludingIds = [excludingIds arrayByAddingObjectsFromArray:@[[KLAccountManager sharedManager].currentUser.userObject.objectId]];
    [query whereKey:sf_key(objectId)
     notContainedIn:excludingIds];
    [query whereKey:sf_key(isRegistered)
            equalTo:@(YES)];
    [query orderByDescending:sf_key(raiting)];
    return query;
}

- (void)insertUsersFromContacts
{
    PFQuery *query = [PFUser query];
    [query includeKey:sf_key(location)];
    [query whereKey:sf_key(phoneNumber)
        containedIn:self.phoneNumbers];
    NSArray *excludingIds = [KLAccountManager sharedManager].currentUser.following;
    excludingIds = [excludingIds arrayByAddingObjectsFromArray:@[[KLAccountManager sharedManager].currentUser.userObject.objectId]];
    [query whereKey:sf_key(objectId)
     notContainedIn:excludingIds];
    [query orderByDescending:sf_key(raiting)];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PF_NULLABLE_S objects, NSError *PF_NULLABLE_S error) {
        if (!error && objects.count) {
            NSMutableArray *newItems = [NSMutableArray array];
            [newItems addObject:weakSelf.items.firstObject];
            [newItems addObjectsFromArray:objects];
            if (weakSelf.items.count>1) {
                for (int i=1; i<weakSelf.items.count; i++) {
                    [newItems addObject:weakSelf.items[i]];
                }
            }
            weakSelf.items = newItems.copy;
        }
    }];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLExplorePeopleCell *cell;
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
    if (indexPath.row == 0 && user.createdEvents.count >= 3) {
        cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klEventListTopUserCell
                                                                      forIndexPath:indexPath];
    } else {
        cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                      forIndexPath:indexPath];
    }
    [cell configureWithUser:user];
    return cell;
}

- (void)notifyLoadFirstPage
{
    [super notifyLoadFirstPage];
    if (self.items.count && self.phoneNumbers) {
        [self insertUsersFromContacts];
    }
}

@end
