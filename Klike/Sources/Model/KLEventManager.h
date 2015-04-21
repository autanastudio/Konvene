//
//  KLEventManager.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLEvent.h"

@class KLEnumObject;

@interface KLEventManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadEvent:(KLEvent *)event
           toServer:(klAccountCompletitionHandler)completition;

- (KLEnumObject *)eventTypeObjectWithId:(NSInteger)enumId;
- (NSArray *)eventTypeEnumObjects;
- (NSArray *)privacyTypeEnumObjects;

@end
