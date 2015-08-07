//
//  KLInvitedListConstoller.m
//  Klike
//
//  Created by Alexey on 7/24/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInvitedListConstoller.h"
#import "KLActivityIndicator.h"
#import "KLInvitedDataSource.h"

static CGFloat klEventListCellHeight = 65.;

@interface KLInvitedListConstoller ()

@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLInvitedListConstoller

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLInvitedDataSource *invitedDataSource = [[KLInvitedDataSource alloc] initWithEvent:self.event];
    return invitedDataSource;
}

- (NSString *)title
{
    return [NSString stringWithFormat:SFLocalized(@"explore.event.count.invited"),
            [NSString abbreviateNumber:self.event.invited.count]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klEventListCellHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 0., 0.);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    PFUser *userObject = [self.dataSource itemAtIndexPath:indexPath];
    KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitedList:openUserProfile:)]) {
        [self.delegate invitedList:self openUserProfile:userWrapper];
    }
}

@end
