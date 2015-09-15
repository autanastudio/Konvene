//
//  NSObject+SF_Additions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

///------------------------------------------
/// @name NSObject
///------------------------------------------

@interface NSObject (SF_Additions)


- (void)subscribeForNotification:(NSString *)name withAction:(SEL)action;

- (void)subscribeForNotification:(NSString *)name withBlock:(void (^)(NSNotification *notification))block;

- (void)subscribeForNotification:(NSString *)name withAction:(SEL)action object:(id)object;

- (void)unsubscribeFromNotification:(NSString *)name;

- (void)unsubscribeFromKeyboardNotifications;

- (void)unsubscribeFromAllNotifications;

- (void)postNotification:(NSNotification *)notification;

- (void)postNotificationWithName:(NSString *)notificationName;

- (void)postNotificationWithName:(NSString *)notificationName object:(id)object;


@end