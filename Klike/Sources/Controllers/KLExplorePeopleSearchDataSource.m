//
//  KLExplorePeopleSearchDataSource.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleSearchDataSource.h"
#import "KLExplorePeopleCell.h"
#import "KLPlaceholderCell.h"

static NSString *klCellReuseId = @"ExplorePeopleCell";

@implementation KLExplorePeopleSearchDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"Sorry, nothing found."
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
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query includeKey:sf_key(location)];
    [query whereKey:sf_key(objectId)
     notContainedIn:@[[KLAccountManager sharedManager].currentUser.userObject.objectId]];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.obscuredByPlaceholder) {
        return [self dequeuePlaceholderViewForTableView:tableView atIndexPath:indexPath];
    } else {
        KLExplorePeopleCell *cell = (KLExplorePeopleCell *)[tableView dequeueReusableCellWithIdentifier:klCellReuseId
                                                                                           forIndexPath:indexPath];
        KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:[self itemAtIndexPath:indexPath]];
        [cell configureWithUser:user];
        if (indexPath.row == self.items.count-1) {
            cell.separator.hidden = YES;
        } else {
            cell.separator.hidden = NO;
        }
        return cell;
    }
}

-(void)loadSearchContentWithQuery:(NSString *)query
{
    [self loadContentWithBlock:^(SFLoading *loading) {
        PFQuery *searchQuery = [self buildQuery];
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
