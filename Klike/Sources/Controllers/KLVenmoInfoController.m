//
//  KLVenmoInfoController.m
//  Klike
//
//  Created by Nick O'Neill on 9/20/15.
//  Copyright © 2015 SFÇD, LLC. All rights reserved.
//

#import "KLVenmoInfoController.h"
#import "KLInviteFriendsViewController.h"
#import "AppDelegate.h"
#import "KLOAuthController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface KLVenmoInfoController () <KLOAuthDelegate>

@property (nonatomic, strong) KLEvent *event;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@end

@implementation KLVenmoInfoController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:@"VENMO ACCOUNT" withColor:[UIColor blackColor] spacing:nil];
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

- (IBAction)connectToVenmo:(id)sender
{
    __weak typeof(self) weakSelf = self;

    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
     withCompletionHandler:^(BOOL success, NSError *error) {
         if (success) {
             NSString *accessToken = [[[Venmo sharedInstance] session] accessToken];
             NSString *userID = [[[[Venmo sharedInstance] session] user] externalId];
             [[KLAccountManager sharedManager] assocVenmoInfo:accessToken andUserID:userID withCompletion:^(BOOL succeeded, NSError *error) {
                 if (succeeded) {
                     [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
                         if (succeeded) {
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
                     }];
                 }
             }];
         }
     }];
}

@end
