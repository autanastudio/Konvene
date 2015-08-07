//
//  KLStatsLayoutControllerViewController.m
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLStatsLayoutController.h"
#import "KLStatsDataSource.h"
#import "KLStatHeaderView.h"

@interface KLStatsLayoutController ()

@property (nonatomic, strong) KLEvent *event;

@property (nonatomic, strong) KLStatHeaderView *header;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) UILabel *sortLabel;

@end

@implementation KLStatsLayoutController

@dynamic header;

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.currentNavigationItem.leftBarButtonItem = self.backButton;
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 64.;
    
    self.sectionHeaderView = [[UIView alloc] init];
    self.sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sortButton = [[UIButton alloc] init];
    [self.sectionHeaderView addSubview:sortButton];
    [sortButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [sortButton addTarget:self
                   action:@selector(onSort)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *sortIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_sort"]];
    [self.sectionHeaderView addSubview:sortIcon];
    [sortIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16.];
    [sortIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.];
    
    self.sortLabel = [[UILabel alloc] init];
    self.sortLabel.text = @"Sort by amount";
    self.sortLabel.font = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
    self.sortLabel.textColor = [UIColor colorFromHex:0x6466ca];
    [self.sectionHeaderView addSubview:self.sortLabel];
    [self.sortLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.sortLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:sortIcon withOffset:4.];
    
    [self layout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.header startAnimation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

- (SFDataSource *)buildDataSource
{
    return [[KLStatsDataSource alloc] initWithEvent:self.event];
}

- (UIView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"StatsHeaderView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (UIView *)buildFooter
{
    UINib *nib = [UINib nibWithNibName:@"CashView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)updateInfo
{
    self.navBarTitle.text = @"STATS";
    [self.header configureWithEvnet:self.event];
    [self refreshList];
    [super updateInfo];
}

- (void)onSort
{
    KLStatsDataSource *dataSource = (KLStatsDataSource *)self.dataSource;
    dataSource.sortByAmount = !dataSource.sortByAmount;
    if (dataSource.sortByAmount) {
        self.sortLabel.text = @"Sort by date";
    } else {
        self.sortLabel.text = @"Sort by amount";
    }
    [self refreshList];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    self.navBarTitle.textColor = [UIColor colorWithWhite:1.-1.*alpha
                                                   alpha:1.];
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.backButton.tintColor = navBarElementsColor;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return nil;
    } else {
        return self.sectionHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return 0.;
    } else {
        return 48.;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return 250.;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
}


@end
