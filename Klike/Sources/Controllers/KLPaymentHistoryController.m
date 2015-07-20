//
//  KLPaymentHistoryController.m
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentHistoryController.h"
#import "KLActivityIndicator.h"
#import "KLPaymentsHistoryDataSource.h"

static CGFloat klEventListCellHeight = 65.;

@interface KLPaymentHistoryController ()

@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation KLPaymentHistoryController

- (SFDataSource *)buildDataSource
{
    KLPaymentsHistoryDataSource *dataSource = [[KLPaymentsHistoryDataSource alloc] init];
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
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self kl_setTitle:SFLocalized(@"settings.payment.history.title")
            withColor:[UIColor blackColor]  spacing:nil];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
}

@end
