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

@interface KLAttendiesList ()

@property (nonatomic, strong) UIBarButtonItem *backButton;
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
    KLAttendiesDataSource *attendiesDataSource = [[KLAttendiesDataSource alloc] init];
    return attendiesDataSource;
}

- (NSString *)title
{
    return @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klEventListCellHeight;
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self kl_setTitle:[NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
                       [NSString abbreviateNumber:self.event.attendees.count]]
            withColor:[UIColor blackColor]];
    
    UINib *nib = [UINib nibWithNibName:@"CreatorCell" bundle:nil];
    self.creatorCell = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    self.tableView.tableHeaderView = self.creatorCell.contentView;
    __weak typeof(self) weakSelf = self;
    [self.event.owner fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            KLUserWrapper *owner = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            [weakSelf.creatorCell configureWithUser:owner];
        }
    }];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *userObject = [self.dataSource itemAtIndexPath:indexPath];
    KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
    [self showUserProfile:userWrapper];
}

@end
