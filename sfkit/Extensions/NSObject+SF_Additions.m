//
//  NSObject+SF_Additions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "NSObject+SF_Additions.h"
#import <objc/runtime.h>

static void * const SFNotificationsObserversKey = @"SFNotificationsObserversKey";

@implementation NSObject (SF_Additions)

- (void)subscribeForNotification:(NSString *)name withAction:(SEL)action {
    [self subscribeForNotification:name withAction:action object:nil];
}

- (void)subscribeForNotification:(NSString *)name withAction:(SEL)action object:(id)object {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:name object:object];
}

- (void)subscribeForNotification:(NSString *)name withBlock:(void (^)(NSNotification *))block {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, SFNotificationsObserversKey);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, SFNotificationsObserversKey, dict, OBJC_ASSOCIATION_RETAIN);
    }
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                                    object:nil
                                                                     queue:[NSOperationQueue currentQueue]
                                                                usingBlock:block];
    dict[name] = observer;
}

- (void)postNotificationWithName:(NSString *)notificationName {
    [self postNotificationWithName:notificationName object:nil];
}

- (void)postNotificationWithName:(NSString *)notificationName object:(id)object {
    NSNotification *notification = [NSNotification notificationWithName:notificationName object:object];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)unsubscribeFromNotification:(NSString *)name {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, SFNotificationsObserversKey);
    if (dict) {
        id observer = dict[name];
        if (observer) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
            [dict removeObjectForKey:name];
        }
        if ([dict count] == 0)
            objc_setAssociatedObject(self, SFNotificationsObserversKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)unsubscribeFromKeyboardNotifications
{
    [self unsubscribeFromNotification:UIKeyboardWillShowNotification];
    [self unsubscribeFromNotification:UIKeyboardDidShowNotification];
    [self unsubscribeFromNotification:UIKeyboardWillHideNotification];
    [self unsubscribeFromNotification:UIKeyboardDidHideNotification];
}

- (void)unsubscribeFromAllNotifications {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, SFNotificationsObserversKey);
    if (dict) {
        for (id observer in dict.allValues) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        [dict removeAllObjects];
        objc_setAssociatedObject(self, SFNotificationsObserversKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)postNotification:(NSNotification *)notification {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    } else {
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end