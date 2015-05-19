//
//  KLEventManager.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEnumObject;

@interface KLLocalReminder : NSObject

@property NSString *eventObjectId;
//@property NSString *remiderId;
@property KLEventReminderType remiderType;

- (NSDictionary*)dictionaryRepresentation;
+ (KLLocalReminder*)remiderFromDictionary:(NSDictionary *)dictionary;
+ (NSDate*)dateForEvenet:(KLEvent*)event forReminderType:(KLEventReminderType)type;

@end

@interface KLEventManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadEvent:(KLEvent *)event
           toServer:(klCompletitionHandlerWithoutObject)completition;
- (void)inviteUser:(KLUserWrapper *)user
           toEvent:(KLEvent *)event
      completition:(klCompletitionHandlerWithObject)completition;
- (BOOL)isUserInvited:(KLUserWrapper*)user toEvent:(KLEvent *)event;
- (void)attendEvent:(KLEvent *)event
       completition:(klCompletitionHandlerWithObject)completition;
- (void)payForEvent:(KLEvent *)event
             amount:(NSNumber *)amount
       completition:(klCompletitionHandlerWithObject)completition;
- (void)buyTickets:(NSNumber *)ticketsCount
          forEvent:(KLEvent *)event
      completition:(klCompletitionHandlerWithObject)completition;

- (void)addToEvent:(KLEvent *)event
             image:(UIImage *)image
      completition:(klCompletitionHandlerWithoutObject)completition;
- (void)addToEvent:(KLEvent *)event
           comment:(NSString *)text
      completition:(klCompletitionHandlerWithoutObject)completition;
- (void)voteForEvent:(KLEvent *)event
           withValue:(NSNumber *)value
        completition:(klCompletitionHandlerWithObject)completition;


- (KLEnumObject *)eventTypeObjectWithId:(NSInteger)enumId;
- (NSArray *)eventTypeEnumObjects;
- (NSArray *)privacyTypeEnumObjects;
- (PFQuery *)getCreatedEventsQueryForUser:(KLUserWrapper *)user;

- (void)friendFromAttendiesForEvent:(KLEvent *)event
                       completition:(klCompletitionHandlerWithObject)completition;
- (void)attendiesForEvent:(KLEvent *)event
                    limit:(NSInteger)limit
             completition:(klCompletitionHandlerWithObjects)completition;

- (void)addReminder:(KLEventReminderType)type toEvent:(KLEvent*)event;
- (void)removeReminder:(KLEventReminderType)type toEvent:(KLEvent*)event;
- (KLLocalReminder*)reminder:(KLEventReminderType)type forEvent:(KLEvent *)event;

@end
