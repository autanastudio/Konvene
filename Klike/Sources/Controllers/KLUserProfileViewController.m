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

@interface KLUserProfileViewController ()
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLUserProfileView *header;

@property (nonatomic, strong) UIView *segmentedContollerTopLine;
@property (nonatomic, strong) UIView *segmentedContollerBottomLine;
@property (nonatomic, strong) KLSegmentedControl *segmentedControl;
@end

@implementation KLUserProfileViewController

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
    
    self.sectionHeaderView = [[UIView alloc] init];
    self.sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.segmentedContollerBottomLine = [[UIView alloc] init];
    self.segmentedContollerBottomLine.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
    self.segmentedContollerTopLine = [[UIView alloc] init];
    self.segmentedContollerTopLine.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
    
    self.segmentedControl = [KLSegmentedControl kl_segmentedControl];
    [(SFSegmentedDataSource *)self.dataSource configureSegmentedControl:self.segmentedControl];
    [self.segmentedControl setContentOffset:CGSizeMake(0, -1)];
    [self.view addSubview:self.segmentedControl];
    
    [self.sectionHeaderView addSubview:self.segmentedContollerBottomLine];
    [self.sectionHeaderView addSubview:self.segmentedContollerTopLine];
    [self.sectionHeaderView addSubview:self.segmentedControl];
    
    [self.segmentedContollerTopLine autoSetDimension:ALDimensionHeight
                                                 toSize:0.5];
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
                                     toSize:56];
    [self.segmentedControl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(1., 0., 0., 0.)
                                                    excludingEdge:ALEdgeBottom];
    [self.segmentedContollerBottomLine autoPinEdge:ALEdgeBottom
                                      toEdge:ALEdgeBottom
                                      ofView:self.segmentedControl
                                  withOffset:0.];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    SFSegmentedDataSource *segmentedDataSource = [[SFSegmentedDataSource alloc] init];
    
    PFQuery *query1 = [KLEvent query];
    query1.limit = 5;
    [query1 includeKey:sf_key(location)];
    
    PFQuery *query2 = [KLEvent query];
    query2.limit = 5;
    [query2 includeKey:sf_key(location)];
    
    PFQuery *query3 = [KLEvent query];
    query3.limit = 5;
    [query3 includeKey:sf_key(location)];
    
    KLEventListDataSource *dataSource = [[KLEventListDataSource alloc] initWithQuery:query1];
    dataSource.title = @"Created";
    
    KLEventListDataSource *dataSource1 = [[KLEventListDataSource alloc] initWithQuery:query2];
    dataSource1.title = @"Going";
    
    KLEventListDataSource *dataSource2 = [[KLEventListDataSource alloc] initWithQuery:query3];
    dataSource2.title = @"Saved";
    
    [segmentedDataSource addDataSource:dataSource];
    [segmentedDataSource addDataSource:dataSource1];
    [segmentedDataSource addDataSource:dataSource2];
    
    return segmentedDataSource;
}

- (void)onSettings
{
    [[KLAccountManager sharedManager] logout];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57.0;
}

@end
