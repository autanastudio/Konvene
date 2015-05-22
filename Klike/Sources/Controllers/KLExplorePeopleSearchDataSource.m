//
//  KLExplorePeopleSearchDataSource.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleSearchDataSource.h"
#import "KLExplorePeopleCell.h"

static NSString *klCellReuseId = @"ExplorePeopleCell";

@implementation KLExplorePeopleSearchDataSource

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCellReuseId];
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query includeKey:sf_key(location)];
    NSArray *excludingIds = [KLAccountManager sharedManager].currentUser.following;
    excludingIds = [excludingIds arrayByAddingObjectsFromArray:@[[KLAccountManager sharedManager].currentUser.userObject.objectId]];
    [query whereKey:sf_key(objectId)
     notContainedIn:excludingIds];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLExplorePeopleCell *cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                                       forIndexPath:indexPath];
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
    [cell configureWithUser:user];
    return cell;
}

-(void)loadSearchContentWithQuery:(NSString *)query
{
    [self loadContentWithBlock:^(SFLoading *loading) {
        PFQuery *searchQuery = [self buildQuery];
        searchQuery.limit = 10;
        [searchQuery whereKey:sf_key(fullName)
               containsString:query];
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *PF_NULLABLE_S objects, NSError *PF_NULLABLE_S error){
            [loading updateWithContent:^(typeof(self) object) {
                object.items = objects;
            }];
        }];
    }];
}

@end
