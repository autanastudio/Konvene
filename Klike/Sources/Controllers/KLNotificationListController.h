//
//  KLNotificationListController.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLNotificationListController;

@protocol KLNotificationListDelegate <NSObject>

- (void)notificationList:(KLNotificationListController *)peopleListControler
         openUserProfile:(KLUserWrapper *)user;
- (void)notificationListOCntroller:(KLNotificationListController *)controller
                  showEventDetails:(KLEvent *)event;

@end

@interface KLNotificationListController : KLListViewController

@property (nonatomic, weak) id<KLNotificationListDelegate> delegate;

@end
