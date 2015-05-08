//
//  KLExplorePeopleListController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleListController.h"
#import "KLExplorePeopleDataSource.h"
#import "KLActivityIndicator.h"

static CGFloat klExplorePeopleCellHeight = 64.;

@interface KLExplorePeopleListController ()

@end

@implementation KLExplorePeopleListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
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

- (SFDataSource *)buildDataSource
{
    KLExplorePeopleDataSource *dataSource = [[KLExplorePeopleDataSource alloc] initWithQuery:[self buildQuery]];
    return dataSource;
}

- (void)refreshList
{
    ((KLPagedDataSource *)self.dataSource).query = [self buildQuery];
    [super refreshList];
}

- (NSString *)title
{
    return SFLocalized(@"explore.people.title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klExplorePeopleCellHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(explorePeopleList:openUserProfile:)]) {
        PFUser *userObject = [self.dataSource itemAtIndexPath:indexPath];
        KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
        [self.delegate explorePeopleList:self openUserProfile:userWrapper];
    }
}

@end
