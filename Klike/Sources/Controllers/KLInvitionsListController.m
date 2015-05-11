//
//  KLInvitionsListController.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInvitionsListController.h"
#import "KLActivityIndicator.h"
#import "KLInvitionsDataSource.h"
#import "KLInvite.h"

static CGFloat klInviteCellHeight = 73.;

@interface KLInvitionsListController ()

@end

@implementation KLInvitionsListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    PFQuery *query = [KLInvite query];
    query.limit = 10;
    [query whereKey:sf_key(to) equalTo:[KLAccountManager sharedManager].currentUser.userObject];
    [query includeKey:sf_key(event)];
    [query includeKey:sf_key(from)];
    [query orderByDescending:sf_key(createdAt)];
    KLInvitionsDataSource *dataSource = [[KLInvitionsDataSource alloc] initWithQuery:query];
    return dataSource;
}

- (NSString *)title
{
    return SFLocalized(@"activity.tab.invites");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klInviteCellHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitionsListOCntroller:showEventDetails:)]) {
        KLInvite *invite = [self.dataSource itemAtIndexPath:indexPath];
        [self.delegate invitionsListOCntroller:self
                              showEventDetails:invite.event];
    }
}

@end
