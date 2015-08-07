//
//  KLUserProfileViewController.m
//  Klike
//
//  Created by admin on 25/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserProfileViewController.h"
#import "KLUserWrapper.h"
#import "KLAccountManager.h"
#import "KLUserView.h"
#import "KLEventListDataSource.h"
#import "KLFollowersController.h"
#import "KLEventListDataSource.h"
#import "KLUserProfileView.h"
#import "SFSegmentedDataSource.h"
#import "KLSegmentedControl.h"
#import "KLStaticDataSource.h"
#import "AppDelegate.h"

@interface KLUserProfileViewController ()
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLUserProfileView *header;

@property (nonatomic, strong) UIView *segmentedContollerTopLine;
@property (nonatomic, strong) UIView *segmentedContollerBottomLine;
@property (nonatomic, strong) KLSegmentedControl *segmentedControl;
@end

@implementation KLUserProfileViewController

@dynamic header;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    if (![self.user isDeleted]) {
        self.sectionHeaderView = [[UIView alloc] init];
        self.sectionHeaderView.backgroundColor = [UIColor whiteColor];
        
        self.segmentedContollerBottomLine = [[UIView alloc] init];
        self.segmentedContollerBottomLine.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
        self.segmentedContollerTopLine = [[UIView alloc] init];
        self.segmentedContollerTopLine.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
        
        self.segmentedControl = [KLSegmentedControl kl_segmentedControl];
        [(SFSegmentedDataSource *)self.dataSource configureSegmentedControl:self.segmentedControl];
        [self.segmentedControl setContentOffset:CGSizeMake(0, -1)];
        self.segmentedControl.customFirstLineWidth = 112.;
        [self.view addSubview:self.segmentedControl];
        
        [self.sectionHeaderView addSubview:self.segmentedContollerBottomLine];
        [self.sectionHeaderView addSubview:self.segmentedContollerTopLine];
        [self.sectionHeaderView addSubview:self.segmentedControl];
        
        [self.segmentedContollerTopLine autoSetDimension:ALDimensionHeight
                                                  toSize:0.5];
        [self.segmentedContollerTopLine autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                         withInset:0.5];
        [self.segmentedContollerTopLine autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                         withInset:0.];
        [self.segmentedContollerTopLine autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                         withInset:0.];
        
        [self.segmentedContollerBottomLine autoSetDimension:ALDimensionHeight
                                                     toSize:3.];
        [self.segmentedContollerBottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                            withInset:0.];
        [self.segmentedContollerBottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                            withInset:0.];
        [self.segmentedControl autoSetDimension:ALDimensionHeight
                                         toSize:57.];
        [self.segmentedControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0., 0., 0., 0.)
                                                        excludingEdge:ALEdgeBottom];
        [self.segmentedContollerBottomLine autoPinEdge:ALEdgeBottom
                                                toEdge:ALEdgeBottom
                                                ofView:self.segmentedControl
                                            withOffset:0.];
    }
    
    [self.header.followButton addTarget:self
                                 action:@selector(onFollow)
                       forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onFollow
{
    BOOL follow = !self.header.isFollowed;
    void (^followBlock)() = ^void(){
        self.header.isFollowed = follow;
        [self.header updateFollowStatus];
        
        [[KLAccountManager sharedManager] follow:follow
                                            user:self.user
                                withCompletition:^(BOOL succeeded, NSError *error) {
                                    
                                }];
    };
    if (follow) {
        followBlock();
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Unfollow %@?", self.user.fullName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* unfollowAction = [UIAlertAction actionWithTitle:@"Unfollow"
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * action) {
                                                                   followBlock();
                                                               }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:unfollowAction];
        [alert addAction:cancelAction];
        [[ADI currentNavigationController] presentViewController:alert animated:YES completion:^{
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    __weak typeof(self) weakSelf = self;
    [self.user.userObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            KLUserWrapper *newUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            weakSelf.user = newUser;
            [weakSelf updateInfo];
        }
    }];
}

- (SFDataSource *)buildDataSource
{
    if (![self.user isDeleted]) {
        SFSegmentedDataSource *segmentedDataSource = [[SFSegmentedDataSource alloc] init];
        
        KLEventListDataSource *createdDataSource = [[KLEventListDataSource alloc] initWithUser:self.user
                                                                                          type:KLEventListDataSourceTypeCreated];
        createdDataSource.title = @"Created";
        createdDataSource.listDelegate = self;
        
        KLEventListDataSource *goingDataSource = [[KLEventListDataSource alloc] initWithUser:self.user
                                                                                        type:KLEventListDataSourceTypeGoing];
        goingDataSource.title = @"Going";
        goingDataSource.listDelegate = self;
        
        KLEventListDataSource *savedDataSource = [[KLEventListDataSource alloc] initWithUser:self.user
                                                                                        type:KLEventListDataSourceTypeSaved];
        savedDataSource.title = @"Saved";
        savedDataSource.listDelegate = self;
        
        [segmentedDataSource addDataSource:createdDataSource];
        [segmentedDataSource addDataSource:goingDataSource];
        [segmentedDataSource addDataSource:savedDataSource];
        
        return segmentedDataSource;
    } else {
        KLStaticDataSource *dataSource = [[KLStaticDataSource alloc] init];
        UINib *nib = [UINib nibWithNibName:@"DeletedUserView" bundle:nil];
        UITableViewCell *deletedCell = [nib instantiateWithOwner:nil
                                                         options:nil].firstObject;
        [dataSource addItem:deletedCell];
        return dataSource;
    }
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.backButton.tintColor = navBarElementsColor;
}

- (UIView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"UserProfileView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

#pragma mark - UIScrollViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if (![self.user isDeleted]) {
        return 57.0;
    } else {
        return 0.;
    }
}

@end
