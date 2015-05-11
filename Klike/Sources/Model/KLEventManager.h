//
//  KLEventManager.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEnumObject;

typedef void(^klCompletitionHandlerWithObject)(id object, NSError *error);
typedef void(^klCompletitionHandlerWithObjects)(NSArray *objects, NSError *error);

@interface KLEventManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadEvent:(KLEvent *)event
           toServer:(klCompletitionHandlerWithoutObject)completition;
- (void)inviteUser:(KLUserWrapper *)user
           toEvent:(KLEvent *)event
      completition:(klCompletitionHandlerWithObject)completition;
- (void)attendEvent:(KLEvent *)event
       completition:(klCompletitionHandlerWithObject)completition;

- (void)addToEvent:(KLEvent *)event
             image:(UIImage *)image
      completition:(klCompletitionHandlerWithoutObject)completition;
- (void)addToEvent:(KLEvent *)event
           comment:(NSString *)text
      completition:(klCompletitionHandlerWithoutObject)completition;

- (KLEnumObject *)eventTypeObjectWithId:(NSInteger)enumId;
- (NSArray *)eventTypeEnumObjects;
- (NSArray *)privacyTypeEnumObjects;
- (PFQuery *)getCreatedEventsQueryForUser:(KLUserWrapper *)user;

- (void)friendFromAttendiesForEvent:(KLEvent *)event
                       completition:(klCompletitionHandlerWithObject)completition;
- (void)attendiesForEvent:(KLEvent *)event
                    limit:(NSInteger)limit
             completition:(klCompletitionHandlerWithObjects)completition;

@end
