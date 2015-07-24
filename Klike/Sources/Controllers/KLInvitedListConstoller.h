//
//  KLInvitedListConstoller.h
//  Klike
//
//  Created by Alexey on 7/24/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLInvitedListConstoller;

@protocol KLInvitedListConstollerDelegate <NSObject>

- (void)invitedList:(KLInvitedListConstoller *)invitedList
    openUserProfile:(KLUserWrapper *)user;

@end

@interface KLInvitedListConstoller : KLListViewController

@property (nonatomic, weak) id<KLInvitedListConstollerDelegate> delegate;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
