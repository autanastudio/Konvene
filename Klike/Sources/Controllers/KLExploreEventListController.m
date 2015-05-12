//
//  KLExploreEventListController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventListController.h"
#import "KLExploreEventDataSource.h"
#import "KLActivityIndicator.h"

static CGFloat klExploreEventCellHeight = 377.;

@interface KLExploreEventListController () <KLExploreEventDataSourceDelegate>

@end

@implementation KLExploreEventListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    PFQuery *query = [KLEvent query];
    query.limit = 3;
    [query includeKey:sf_key(location)];
    [query includeKey:sf_key(price)];
    [query orderByDescending:sf_key(createdAt)];
    KLExploreEventDataSource *dataSource = [[KLExploreEventDataSource alloc] initWithQuery:query];
    dataSource.listDelegate = self;
    return dataSource;
}

- (NSString *)title
{
    return SFLocalized(@"explore.events.title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klExploreEventCellHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(exploreEventListOCntroller:showEventDetails:)]) {
        [self.delegate exploreEventListOCntroller:self
                                 showEventDetails:[self.dataSource itemAtIndexPath:indexPath]];
    }
}

#pragma mark - KLExploreEventDataSourceDelegate methods

- (void)exploreEventDataSource:(KLExploreEventDataSource *)dataSource
         showAttendiesForEvent:(KLEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(exploreEventListOCntroller:showAttendiesForEvent:)]) {
        [self.delegate exploreEventListOCntroller:self
                            showAttendiesForEvent:event];
    }
}

@end
