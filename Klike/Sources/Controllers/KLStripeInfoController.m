//
//  KLStripeInfoController.m
//  Klike
//
//  Created by Alexey on 6/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLStripeInfoController.h"
#import "KLInviteFriendsViewController.h"
#import "AppDelegate.h"
#import "KLOAuthController.h"

@interface KLStripeInfoController () <KLOAuthDelegate>

@property (nonatomic, strong) KLEvent *event;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@end

@implementation KLStripeInfoController

- (instancetype)initWithEvent:(KLEvent *)event
{
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorFromHex:0x6465c6]];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.currentNavigationItem.leftBarButtonItem = self.backButton;
    
//    self.nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"event_right_arr_whight"]
//                                                       style:UIBarButtonItemStyleDone
//                                                      target:self
//                                                      action:@selector(onNext)];
//    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:@"STRIPE ACCOUNT" withColor:[UIColor blackColor] spacing:nil];
    self.currentNavigationItem.hidesBackButton = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - Action

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onNext
{
    NSString *stripeId = self.event.price.stripeId;
    if (stripeId) {
        __weak typeof(self) weakSelf = self;
        [[KLEventManager sharedManager] uploadEvent:self.event toServer:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [weakSelf.delegate dissmissCreateEvent];
            }
            
            KLInviteFriendsViewController *vc = [[KLInviteFriendsViewController alloc] init];
            vc.inviteType = KLInviteTypeEvent;
            vc.isEventJustCreated = YES;
            vc.isAfterSignIn = NO;
            vc.needBackButton = YES;
            vc.event = self.event;
            [ADI.currentNavigationController pushViewController:vc animated:YES];
        }];
    }
    
}

- (IBAction)connectToStripe:(id)sender
{
    KLOAuthController *oAuthController = [KLOAuthController oAuthcontrollerForStripe];
    oAuthController.delegate = self;
    [self presentViewController:oAuthController animated:YES completion:^{
        
    }];
}

#pragma mark - Delegate methods

- (void)oAuthViewController:(KLOAuthController *)viewController
         didSucceedWithUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    NSString *stripeId = user[sf_key(stripeId)];
    if ((stripeId && [stripeId notEmpty])) {
        __weak typeof(self) weakSelf = self;
        [[KLEventManager sharedManager] uploadEvent:self.event toServer:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [weakSelf.delegate dissmissCreateEvent];
            }
            KLInviteFriendsViewController *vc = [[KLInviteFriendsViewController alloc] init];
            vc.inviteType = KLInviteTypeEvent;
            vc.isEventJustCreated = YES;
            vc.isAfterSignIn = NO;
            vc.needBackButton = YES;
            vc.event = weakSelf.event;
            [ADI.currentNavigationController pushViewController:vc animated:YES];
        }];
    }
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
