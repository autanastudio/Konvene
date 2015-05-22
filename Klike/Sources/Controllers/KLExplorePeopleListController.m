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
#import "KLExploreTopUserView.h"

static CGFloat klExplorePeopleCellHeight = 64.;

@interface KLExplorePeopleListController () {
    KLExploreTopUserView *_header;
}

@end

@implementation KLExplorePeopleListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLExplorePeopleDataSource *dataSource = [[KLExplorePeopleDataSource alloc] init];
    return dataSource;
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
    [self updateTopUserView];
}

- (void)refreshList
{
    [super refreshList];
    [self updateTopUserView];
}

- (void)updateTopUserView
{
    __weak typeof(self) weakSelf = self;
    [[KLEventManager sharedManager] topUser:^(id object, NSError *error) {
        if (object) {
            weakSelf.tableView.tableHeaderView = nil;
            _header = [KLExploreTopUserView createTopUserView];
            weakSelf.tableView.tableHeaderView = _header;
            [_header buildWithUser:[[KLUserWrapper alloc] initWithUserObject:object]];
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }
    }];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(explorePeopleList:openUserProfile:)]) {
        PFUser *userObject = [self.dataSource itemAtIndexPath:indexPath];
        KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
        [self.delegate explorePeopleList:self openUserProfile:userWrapper];
    }
}

@end
