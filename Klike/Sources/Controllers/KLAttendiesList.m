//
//  KLAttendiesList.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAttendiesList.h"
#import "KLUserListDataSource.h"
#import "KLActivityIndicator.h"
#import "SFComposedDataSource.h"
#import "KLStaticDataSource.h"
#import "KLCreatorCell.h"
#import "KLAttendiesDataSource.h"

static CGFloat klEventListCellHeight = 65.;

@interface KLAttendiesList () <KLCreatorCellDelegate>

@property (nonatomic, strong) KLEvent *event;
@property (nonatomic, strong) KLCreatorCell *creatorCell;

@end

@implementation KLAttendiesList

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
    KLAttendiesDataSource *attendiesDataSource = [[KLAttendiesDataSource alloc] initWithEvent:self.event];
    return attendiesDataSource;
}

- (NSString *)title
{
    return [NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
            [NSString abbreviateNumber:self.event.attendees.count]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klEventListCellHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 0., 0);
    
    UINib *nib = [UINib nibWithNibName:@"CreatorCell" bundle:nil];
    self.creatorCell = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    self.creatorCell.delegate = self;
    self.tableView.tableHeaderView = self.creatorCell.contentView;
    __weak typeof(self) weakSelf = self;
    [self.event.owner fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            KLUserWrapper *owner = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            [weakSelf.creatorCell configureWithUser:owner];
        }
    }];
}

#pragma mark - KLCreatorCellDelegate <NSObject>

- (void)creatorCellDelegateDidPress
{
    PFUser *userObject = self.event.owner;
    KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
    if (self.delegate && [self.delegate respondsToSelector:@selector(attendiesList:openUserProfile:)]) {
        [self.delegate attendiesList:self openUserProfile:userWrapper];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    PFUser *userObject = [self.dataSource itemAtIndexPath:indexPath];
    KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
    if (self.delegate && [self.delegate respondsToSelector:@selector(attendiesList:openUserProfile:)]) {
        [self.delegate attendiesList:self openUserProfile:userWrapper];
    }
}

@end
