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
    [self kl_setTitle:SFLocalized(@"activity.title") withColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
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
