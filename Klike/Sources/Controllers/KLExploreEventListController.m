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

@property (nonatomic, assign) BOOL needScrollToTop;

@end

@implementation KLExploreEventListController

- (instancetype)init
{
    if (self = [super init]) {
        self.needScrollToTop = YES;
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLExploreEventDataSource *dataSource = [[KLExploreEventDataSource alloc] init];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needScrollToTop) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    } else {
        self.needScrollToTop = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(exploreEventListOCntroller:showEventDetails:)]) {
        self.needScrollToTop = NO;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectedEventOffset = [self.view.window convertPoint:CGPointMake(0, 0) fromView:cell];
        
        [self.delegate exploreEventListOCntroller:self
                                 showEventDetails:[self.dataSource itemAtIndexPath:indexPath]];
    }
}

#pragma mark - KLExploreEventDataSourceDelegate methods

- (void)exploreEventDataSource:(KLExploreEventDataSource *)dataSource
         showAttendiesForEvent:(KLEvent *)event
{
    self.needScrollToTop = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(exploreEventListOCntroller:showAttendiesForEvent:)]) {
        [self.delegate exploreEventListOCntroller:self
                            showAttendiesForEvent:event];
    }
}

@end
