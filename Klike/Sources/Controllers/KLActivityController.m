//
//  KLActivityController.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityController.h"
#import "KLNotificationListController.h"
#import "KLInvitionsListController.h"

@interface KLActivityController () <KLInvitionsListDelegate, KLNotificationListDelegate>

@end


@implementation KLActivityController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        KLNotificationListController *notifications = [[KLNotificationListController alloc] init];
        notifications.delegate = self;
        KLInvitionsListController *invititions = [[KLInvitionsListController alloc] init];
        invititions.delegate = self;
        self.childControllers = @[notifications, invititions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:SFLocalized(@"activity.title") withColor:[UIColor blackColor] spacing:nil];
    self.currentNavigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] updateUserData:^(BOOL succeeded, NSError *error) {
        KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
        if ([currentUser.invited boolValue]) {
            [weakSelf.segmentedControl showBadgeOnIndex:1];
        }
    }];
}

- (void)onSegmentValueChanged
{
    [super onSegmentValueChanged];
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index == 1) {
        [self.segmentedControl hideBadge];
        KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
        currentUser.invited = @(0);
        [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
            
        }];
    }
}

#pragma mark - delegate methods

- (void)invitionsListOCntroller:(KLInvitionsListController *)controller
               showEventDetails:(KLEvent *)event
{
    [self showEventDetails:event];
}

- (void)notificationList:(KLNotificationListController *)peopleListControler
          openUserProfile:(KLUserWrapper *)user
{
    [self showUserProfile:user];
}

- (void)notificationListOCntroller:(KLNotificationListController *)controller
             showEventDetails:(KLEvent *)event
{
    [self showEventDetails:event];
}

@end
