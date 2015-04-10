//
//  KLEventManager.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventManager.h"

@implementation KLEventManager

+ (instancetype)sharedManager {
    static KLEventManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)uploadEvent:(KLEvent *)event
           toServer:(klAccountCompletitionHandler)completition
{
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completition(succeeded, error);
    }];
}

@end
