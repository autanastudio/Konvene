//
//  KLPaySettingsViewController.m
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaySettingsViewController.h"
#import "KLCardDataSource.h"
#import "KLPaySettingsFooter.h"
#import "KLAddCardController.h"
#import "KLActivityIndicator.h"
#import "KLPaymentHistoryController.h"

static CGFloat klCardCellHeight = 84.;

@interface KLPaySettingsViewController ()

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLPaySettingsFooter *footer;

@end

@implementation KLPaySettingsViewController

- (SFDataSource *)buildDataSource
{
    KLCardDataSource *dataSource = [[KLCardDataSource alloc] init];
    return dataSource;
}

- (NSString *)title
{
    return @"";
}

- (KLPaySettingsFooter *)buildFooter
{
    UINib *nib = [UINib nibWithNibName:@"PaySettingsFooter" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klCardCellHeight;
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    self.footer = [self buildFooter];
    self.tableView.tableFooterView = self.footer;
    [self.footer.addCardButton addTarget:self
                                  action:@selector(onAddCard)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.footer.paymentHistoryButton addTarget:self
                                         action:@selector(onPaymentHistory)
                               forControlEvents:UIControlEventTouchUpInside];
    
    NSString *capitalizedTitle = [SFLocalized(@"settings.menu.payment") capitalizedString];
    [self kl_setTitle:capitalizedTitle withColor:[UIColor blackColor]];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onAddCard
{
    KLAddCardController *addCard = [[KLAddCardController alloc] init];
    [self.navigationController pushViewController:addCard
                                         animated:YES];
}

- (void)onPaymentHistory
{
    KLPaymentHistoryController *paymentHistory = [[KLPaymentHistoryController alloc] init];
    [self.navigationController pushViewController:paymentHistory
                                         animated:YES];
}

@end
