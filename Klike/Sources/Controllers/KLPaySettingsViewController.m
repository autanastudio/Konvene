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
#import "KLOAuthController.h"

static CGFloat klCardCellHeight = 84.;

@interface KLPaySettingsViewController () <KLOAuthDelegate>

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
    self.currentNavigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    self.footer = [self buildFooter];
    self.tableView.tableFooterView = self.footer;
    [self updateStripeConnectButton];
    [self.footer.addCardButton addTarget:self
                                  action:@selector(onAddCard)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.footer.connectToStripeButton addTarget:self
                                          action:@selector(onConnectToStripe)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.footer.paymentHistoryButton addTarget:self
                                         action:@selector(onPaymentHistory)
                               forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *capitalizedTitle = [SFLocalized(@"settings.menu.payment") uppercaseString];
    [self kl_setTitle:capitalizedTitle withColor:[UIColor blackColor] spacing:nil];
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

- (void)updateStripeConnectButton
{
    NSString *stripeId = [KLAccountManager sharedManager].currentUser.stripeId;
    if (stripeId && [stripeId notEmpty]) {
        [self.footer.connectToStripeButton setTitle:@"Logout Stripe"
                                           forState:UIControlStateNormal];
    } else {
        [self.footer.connectToStripeButton setTitle:@"Connect to Stripe"
                                           forState:UIControlStateNormal];
    }
}

- (void)onConnectToStripe
{
    NSString *stripeId = [KLAccountManager sharedManager].currentUser.stripeId;
    if (stripeId && [stripeId notEmpty]) {
        __weak typeof(self) weakSelf = self;
        [KLAccountManager sharedManager].currentUser.userObject[sf_key(stripeId)] = @"";
        [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [weakSelf updateStripeConnectButton];
            }
        }];
    } else {
        KLOAuthController *oAuthController = [KLOAuthController oAuthcontrollerForStripe];
        oAuthController.delegate = self;
        [self presentViewController:oAuthController animated:YES completion:^{
            
        }];
    }
}

- (void)onPaymentHistory
{
    KLPaymentHistoryController *paymentHistory = [[KLPaymentHistoryController alloc] init];
    [self.navigationController pushViewController:paymentHistory
                                         animated:YES];
}

#pragma mark - Delegate methods

- (void)oAuthViewController:(KLOAuthController *)viewController
         didSucceedWithUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] updateUserData:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf updateStripeConnectButton];
        }
    }];
}

- (void)oAuthViewController:(KLOAuthController *)viewController
           didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    NSString *description = error.userInfo[NSLocalizedDescriptionKey];
    [self showNavbarwithErrorMessage:description];
}

@end
