//
//  KLEventListController.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListController.h"
#import "KLEventListDataSource.h"
#import "KLActivityIndicator.h"

static CGFloat klEventListCellHeight = 177.;

@interface KLEventListController () <KLEventListDataSourceDelegate>

@property (nonatomic, assign) KLEventListDataSourceType type;

@end

@implementation KLEventListController

- (instancetype)initWithType:(KLEventListDataSourceType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLEventListDataSource *dataSource = [[KLEventListDataSource alloc] init];
    dataSource.type = self.type;
    dataSource.listDelegate = self;
    return dataSource;
}

- (NSString *)title
{
    switch (self.type) {
        case KLEventListDataSourceTypeGoing:
            return SFLocalized(@"event.myevent.going.title");
            break;
        case KLEventListDataSourceTypeSaved:
            return SFLocalized(@"event.myevent.saved.title");
            break;
        default:
            return @"";
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klEventListCellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventListOCntroller:showEventDetails:)]) {
        [self.delegate eventListOCntroller:self
                          showEventDetails:[self.dataSource itemAtIndexPath:indexPath]];
    }
}

#pragma  mark - KLEventListDataSourceDelegate methods

- (void)eventListDataSource:(KLEventListDataSource *)dataSource
      showAttendiesForEvent:(KLEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventListOCntroller:showAttendiesForEvent:)]) {
        [self.delegate eventListOCntroller:self
                     showAttendiesForEvent:event];
    }
}

@end
