//
//  KLUserList.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserList.h"
#import "KLActivityIndicator.h"
#import "KLUserListDataSource.h"

static CGFloat klEventListCellHeight = 65.;

@interface KLUserList ()

@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation KLUserList

- (SFDataSource *)buildDataSource
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query includeKey:sf_key(location)];
    KLUserListDataSource *dataSource = [[KLUserListDataSource alloc] initWithQuery:query];
    return dataSource;
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
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end