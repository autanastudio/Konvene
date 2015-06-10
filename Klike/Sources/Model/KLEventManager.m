//
//  KLEventManager.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventManager.h"
#import <EventKit/EventKit.h>
#import "DateTools.h"

static NSString *klInviteUserCloudeFunctionName = @"invite";
static NSString *klAttendEventCloudeFunctionName = @"attend";
static NSString *klVoteEventCloudeFunctionName = @"vote";
static NSString *klInviteUserInvitedIdKey = @"invitedId";
static NSString *klIsInviteKey = @"isInvite";
static NSString *klInviteUserEventIdKey = @"eventId";
static NSString *klVoteValueKey = @"voteValue";
static NSString *klThrowInClodeFunctionName = @"throwIn";
static NSString *klBuyTicketsClodeFunctionName = @"buyTickets";
static NSString *klCardIdKey = @"cardId";
static NSString *klPayValueKey = @"payValue";

@implementation KLLocalReminder

- (NSDictionary*)dictionaryRepresentation
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.eventObjectId forKey:@"eventObjectId"];
    [result setObject:[NSNumber numberWithInt:self.remiderType] forKey:@"remiderType"];
    return result;
}

+ (KLLocalReminder*)remiderFromDictionary:(NSDictionary *)dictionary
{
    KLLocalReminder *result = [[KLLocalReminder alloc] init];
    result.remiderType = [[dictionary objectForKey:@"remiderType"]intValue];
    result.eventObjectId = [dictionary objectForKey:@"eventObjectId"];
    return result;
}

+ (NSDate*)dateForEvenet:(KLEvent*)event forReminderType:(KLEventReminderType)type
{
    switch (type) {
        case KLEventReminderTypeInTime:
            return event.startDate;
            break;
        case KLEventReminderType5m:
            return [event.startDate dateBySubtractingMinutes:5];
            break;
        case KLEventReminderType15m:
            return [event.startDate dateBySubtractingMinutes:15];
            break;
        case KLEventReminderType30m:
            return [event.startDate dateBySubtractingMinutes:30];
            break;
        case KLEventReminderType1h:
            return [event.startDate dateBySubtractingHours:1];
            break;
        case KLEventReminderType2h:
            return [event.startDate dateBySubtractingHours:2];
            break;
        case KLEventReminderType1d:
            return [event.startDate dateBySubtractingDays:1];
            break;
        case KLEventReminderType2d:
            return [event.startDate dateBySubtractingDays:2];
            break;
        default:
            break;
    }
    return event.startDate;
}

+ (NSString *)textForEvent:(KLEvent *)event forReminderType:(KLEventReminderType)type
{
    NSString *title;
    switch (type) {
        case KLEventReminderTypeInTime:
            title = @"\"%@\" has started";
            break;
        case KLEventReminderType5m:
            title = @"5 minutes left for \"%@\"";
            break;
        case KLEventReminderType15m:
            title = @"15 minutes left for \"%@\"";
            break;
        case KLEventReminderType30m:
            title = @"30 minutes left for \"%@\"";
            break;
        case KLEventReminderType1h:
            title = @"One hour left for \"%@\"";
            break;
        case KLEventReminderType2h:
            title = @"Two hours left for \"%@\"";
            break;
        case KLEventReminderType1d:
            title = @"One day left for \"%@\"";
            break;
        case KLEventReminderType2d:
            title = @"Two days left for \"%@\"";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:title, event.title];
}

@end



@interface KLEventManager ()

@property (nonatomic, strong) NSArray *eventTypeObjects;

@end

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
           toServer:(klCompletitionHandlerWithoutObject)completition
{
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completition(succeeded, error);
    }];
}

- (void)inviteUser:(KLUserWrapper *)user
           toEvent:(KLEvent *)event
          isInvite:(BOOL)isInvite
      completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klInviteUserCloudeFunctionName
                       withParameters:@{ klInviteUserInvitedIdKey : user.userObject.objectId ,
                                         klInviteUserEventIdKey : event.objectId,
                                         klIsInviteKey : @(isInvite)}
                                block:^(id object, NSError *error) {
                                    
                                    if (!error) {
                                        completition(object, nil);
                                    } else {
                                        completition(nil, error);
                                    }
                                }];
}

- (BOOL)isUserInvited:(KLUserWrapper*)user toEvent:(KLEvent *)event
{
    if ([event.invited containsObject:user.userObject.objectId]) {
        return YES;
    }
    return NO;
}

- (void)attendEvent:(KLEvent *)event
       completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klAttendEventCloudeFunctionName
                       withParameters:@{ klInviteUserEventIdKey : event.objectId }
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        completition(object, nil);
                                    } else {
                                        completition(nil, error);
                                    }
                                }];
}

- (void)addToEvent:(KLEvent *)event
             image:(UIImage *)image
      completition:(klCompletitionHandlerWithoutObject)completition
{
    if (event.extension.isDataAvailable) {
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *newImage = [PFFile fileWithData:imageData];
        [event.extension addUniqueObject:newImage
                                  forKey:sf_key(photos)];
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFQuery *findActivity = [KLActivity query];
                [findActivity whereKey:sf_key(activityType)
                               equalTo:@(KLActivityTypePhotosAdded)];
                [findActivity whereKey:sf_key(event)
                               equalTo:event];
                [findActivity getFirstObjectInBackgroundWithBlock:^(id object, NSError *error) {
                    KLActivity *tempActivity = (KLActivity *)object;
                    if (!tempActivity) {
                        tempActivity = [KLActivity object];
                        tempActivity.activityType = @(KLActivityTypePhotosAdded);
                        tempActivity.from = [KLAccountManager sharedManager].currentUser.userObject;
                        [tempActivity addUniqueObject:event.owner.objectId
                                              forKey:sf_key(observers)];
                        tempActivity.event = event;
                    }
                    [tempActivity addUniqueObject:newImage
                                           forKey:sf_key(photos)];
                    [tempActivity saveInBackground];
                }];
                completition(YES, nil);
            } else {
                completition(NO, error);
            }
        }];
    } else {
        completition(NO, nil);
    }
}

- (void)addToEvent:(KLEvent *)event
           comment:(NSString *)text
      completition:(klCompletitionHandlerWithoutObject)completition
{
    if (event.extension.isDataAvailable) {
        KLEventComment *comment = [KLEventComment object];
        comment.text = text;
        comment.owner = [KLAccountManager sharedManager].currentUser.userObject;
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [event.extension addUniqueObject:comment.objectId
                                          forKey:sf_key(comments)];
                
                KLActivity *newActivity = [KLActivity object];
                newActivity.activityType = @(KLActivityTypeCommentAdded);
                newActivity.from = [KLAccountManager sharedManager].currentUser.userObject;
                [newActivity addUniqueObject:event.owner.objectId
                                      forKey:sf_key(observers)];
                newActivity.event = event;
                [newActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        
                        completition(YES, nil);
                    } else {
                        completition(NO, error);
                    }
                }];
            } else {
                completition(NO, error);
            }
        }];
    } else {
        completition(NO, nil);
    }
}

- (void)deleteComment:(KLEvent *)event
              comment:(KLEventComment *)comment
         completition:(klCompletitionHandlerWithoutObject)completition
{
    if (event.extension.isDataAvailable) {
        [event.extension removeObject:comment.objectId forKey:sf_key(comments)];
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [comment deleteInBackground];
                completition(YES, nil);
            } else {
                completition(NO, error);
            }
        }];
    } else {
        completition(NO, nil);
    }
}

- (void)voteForEvent:(KLEvent *)event
           withValue:(NSNumber *)value
        completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klVoteEventCloudeFunctionName
                       withParameters:@{ klVoteValueKey : value ,
                                         klInviteUserEventIdKey : event.objectId}
                                block:^(id object, NSError *error) {
                                    
                                    if (!error) {
                                        completition(object, nil);
                                    } else {
                                        completition(nil, error);
                                    }
                                }];
}

- (KLEnumObject *)eventTypeObjectWithId:(NSInteger)enumId
{
    NSArray *objects = [self eventTypeEnumObjects];
    if (enumId<objects.count) {
        return objects[enumId];
    } else {
        return nil;
    }
}

- (NSArray *)eventTypeEnumObjects
{
    if (!_eventTypeObjects) {
        NSArray *typeTitles = @[SFLocalized(@"event.type.title.None"),
                                SFLocalized(@"event.type.title.Birthday"),
                                SFLocalized(@"event.type.title.GetTogether"),
                                SFLocalized(@"event.type.title.Meeting"),
                                SFLocalized(@"event.type.title.PoolParty"),
                                SFLocalized(@"event.type.title.Holiday"),
                                SFLocalized(@"event.type.title.Pre-Game"),
                                SFLocalized(@"event.type.title.DayParty"),
                                SFLocalized(@"event.type.title.StudySession"),
                                SFLocalized(@"event.type.title.Eating_Out"),
                                SFLocalized(@"event.type.title.Music_Event"),
                                SFLocalized(@"event.type.title.Trip"),
                                SFLocalized(@"event.type.title.Party")];
        NSArray *typeIcons = @[@"",
                               @"ic_event_type_01",
                               @"ic_event_type_02",
                               @"ic_event_type_03",
                               @"ic_event_type_04",
                               @"ic_event_type_05",
                               @"ic_event_type_06",
                               @"ic_event_type_07",
                               @"ic_event_type_08",
                               @"ic_event_type_09",
                               @"ic_event_type_10",
                               @"ic_event_type_11",
                               @"ic_event_type_12",];
        NSMutableArray *objects = [NSMutableArray array];
        for (NSUInteger i =0; i<KLEventTypeCount; i++) {
            KLEnumObject *object = [[KLEnumObject alloc] initWithEnumId:i
                                                                   type:KLEnumTypeEventType
                                                               iconName:typeIcons[i]
                                                            descritpion:typeTitles[i]];
            [objects addObject:object];
        }
        _eventTypeObjects = objects;
    }
    return _eventTypeObjects;
}

- (NSArray *)privacyTypeEnumObjects
{
    NSArray *typeTitles = @[SFLocalized(@"event.privacy.public.title"),
                            SFLocalized(@"event.privacy.private.title"),
                            SFLocalized(@"event.privacy.privateplus.title")];
    NSArray *typeDescription = @[SFLocalized(@"event.privacy.public"),
                                 SFLocalized(@"event.privacy.private"),
                                 SFLocalized(@"event.privacy.privateplus")];
    NSArray *typeIcons  = @[@"event_public",
                            @"event_private",
                            @"ic_private_plus"];
    NSMutableArray *objects = [NSMutableArray array];
    for (NSUInteger i =0; i<KLEventPrivacyTypeCount; i++) {
        KLEnumObject *object = [[KLEnumObject alloc] initWithEnumId:i
                                                               type:KLEnumTypePrivacy
                                                           iconName:typeIcons[i]
                                                        descritpion:typeTitles[i]
                                              additionalDescription:typeDescription[i]];
        [objects addObject:object];
    }
    return objects;
}

- (PFQuery *)getCreatedEventsQueryForUser:(KLUserWrapper *)user
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    if (!user) {
        user = [KLAccountManager sharedManager].currentUser;
        PFQuery *eventQuery = [KLEvent query];
        [eventQuery whereKey:sf_key(objectId)
                 containedIn:user.createdEvents];
        return eventQuery;
    } else {
        PFQuery *publicQuery = [KLEvent query];
        [publicQuery whereKey:sf_key(objectId)
                 containedIn:user.createdEvents];
        if (currentUser) {
            [publicQuery whereKey:sf_key(owner)
                       notEqualTo:currentUser.userObject];
        }
        [publicQuery whereKey:sf_key(privacy)
                      equalTo:@(KLEventPrivacyTypePublic)];
        
        PFQuery *privateQuery = [KLEvent query];
        [privateQuery whereKey:sf_key(objectId)
                 containedIn:user.createdEvents];
        if (currentUser) {
            [privateQuery whereKey:sf_key(owner)
                        notEqualTo:currentUser.userObject];
        }
        [privateQuery whereKey:sf_key(privacy)
                   containedIn:@[@(KLEventPrivacyTypePrivate), @(KLEventPrivacyTypePrivatePlus)]];
        [privateQuery whereKey:sf_key(invited)
                       equalTo:currentUser.userObject.objectId];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[publicQuery, privateQuery]];
        return query;
    }
}

- (PFQuery *)getGoingEventsQueryForUser:(KLUserWrapper *)user
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    if (!user) {
        user = [KLAccountManager sharedManager].currentUser;
        PFQuery *eventQuery = [KLEvent query];
        [eventQuery whereKey:sf_key(attendees)
                     equalTo:user.userObject.objectId];
        return eventQuery;
    } else {
        PFQuery *publicQuery = [KLEvent query];
        [publicQuery whereKey:sf_key(attendees)
                     equalTo:user.userObject.objectId];
        if (currentUser) {
            [publicQuery whereKey:sf_key(owner)
                       notEqualTo:currentUser.userObject];
        }
        [publicQuery whereKey:sf_key(privacy)
                      equalTo:@(KLEventPrivacyTypePublic)];
        
        PFQuery *privateQuery = [KLEvent query];
        [privateQuery whereKey:sf_key(attendees)
                     equalTo:user.userObject.objectId];
        if (currentUser) {
            [privateQuery whereKey:sf_key(owner)
                        notEqualTo:currentUser.userObject];
        }
        [privateQuery whereKey:sf_key(privacy)
                   containedIn:@[@(KLEventPrivacyTypePrivate), @(KLEventPrivacyTypePrivatePlus)]];
        [privateQuery whereKey:sf_key(invited)
                       equalTo:currentUser.userObject.objectId];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[publicQuery, privateQuery]];
        return query;
    }
}

- (PFQuery *)getSavedEventsQueryForUser:(KLUserWrapper *)user
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    if (!user) {
        user = [KLAccountManager sharedManager].currentUser;
        PFQuery *eventQuery = [KLEvent query];
        [eventQuery whereKey:sf_key(savers)
                     equalTo:user.userObject.objectId];
        return eventQuery;
    } else {
        PFQuery *publicQuery = [KLEvent query];
        [publicQuery whereKey:sf_key(savers)
                     equalTo:user.userObject.objectId];
        if (currentUser) {
            [publicQuery whereKey:sf_key(owner)
                       notEqualTo:currentUser.userObject];
        }
        [publicQuery whereKey:sf_key(privacy)
                      equalTo:@(KLEventPrivacyTypePublic)];
        
        PFQuery *privateQuery = [KLEvent query];
        [privateQuery whereKey:sf_key(savers)
                     equalTo:user.userObject.objectId];
        if (currentUser) {
            [privateQuery whereKey:sf_key(owner)
                        notEqualTo:currentUser.userObject];
        }
        [privateQuery whereKey:sf_key(privacy)
                   containedIn:@[@(KLEventPrivacyTypePrivate), @(KLEventPrivacyTypePrivatePlus)]];
        [privateQuery whereKey:sf_key(invited)
                       equalTo:currentUser.userObject.objectId];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[publicQuery, privateQuery]];
        return query;
    }
}

- (void)friendFromAttendiesForEvent:(KLEvent *)event
                       completition:(klCompletitionHandlerWithObject)completition
{
    NSString *friendId = nil;
    for (NSString *follingId in [KLAccountManager sharedManager].currentUser.following) {
        if ([event.attendees indexOfObject:follingId]!=NSNotFound) {
            friendId = follingId;
        }
    }
    if (!friendId) {
        completition(nil, nil);
    }
    PFUser *friend = [PFUser objectWithoutDataWithClassName:[PFUser parseClassName] objectId:friendId];
    [friend fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            KLUserWrapper *newUser = [[KLUserWrapper alloc] initWithUserObject:(PFUser *)object];
            completition(newUser, nil);
        } else {
            completition(nil, error);
        }
    }];
}

- (void)attendiesForEvent:(KLEvent *)event
                    limit:(NSInteger)limit
             completition:(klCompletitionHandlerWithObjects)completition
{
    PFQuery *query = [PFUser query];
    [query whereKey:sf_key(objectId) containedIn:event.attendees];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completition(objects, error);
    }];
}

- (void)saveEvent:(KLEvent *)event
             save:(BOOL)save
     completition:(klCompletitionHandlerWithObject)completition
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    if (save) {
        [event addUniqueObject:currentUser.userObject.objectId
                        forKey:sf_key(savers)];
    } else {
        [event removeObject:currentUser.userObject.objectId
                     forKey:sf_key(savers)];
    }
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            completition(event, nil);
        } else {
            completition(nil, error);
        }
    }];
}


- (void)addReminder:(KLEventReminderType)type toEvent:(KLEvent*)event
{
    NSMutableArray *reminders = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"] mutableCopy];
    if (!reminders)
        reminders = [NSMutableArray array];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [KLLocalReminder dateForEvenet:event forReminderType:type];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [KLLocalReminder textForEvent:event forReminderType:type];
    localNotif.alertTitle = @"Reminder";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:event.objectId forKey:@"objectId"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    KLLocalReminder *localReminder = [[KLLocalReminder alloc] init];
    localReminder.eventObjectId = event.objectId;
    localReminder.remiderType = type;
    [reminders addObject:[localReminder dictionaryRepresentation]];
    
    [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeReminder:(KLEventReminderType)type toEvent:(KLEvent*)event
{
    NSMutableArray *reminders = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"] mutableCopy];
    
    for (NSDictionary *dictionary in reminders)
    {
        KLLocalReminder *r = [KLLocalReminder remiderFromDictionary:dictionary];
        if ([r.eventObjectId isEqualToString:event.objectId] &&
            r.remiderType == type) {
     
            //remove reminder
            for (UILocalNotification *l in [[UIApplication sharedApplication] scheduledLocalNotifications])
            {
                if ([[l.userInfo objectForKey:@"objectId"] isEqualToString:event.objectId]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:l];
                    break;
                }
            }
            
            [reminders removeObject:dictionary];
            break;
            
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (KLLocalReminder*)reminder:(KLEventReminderType)type forEvent:(KLEvent *)event
{
    NSMutableArray *reminders = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"] mutableCopy];

    for (NSDictionary *dictionary in reminders)
    {
        KLLocalReminder *r = [KLLocalReminder remiderFromDictionary:dictionary];
        if ([r.eventObjectId isEqualToString:event.objectId] &&
            r.remiderType == type) {
            return r;
        }
    }
    return nil;
}

- (void)payAmount:(NSNumber *)amount
             card:(KLCard *)card
         forEvent:(KLEvent *)event
     completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klThrowInClodeFunctionName
                       withParameters:@{ klPayValueKey : amount ,
                                         klInviteUserEventIdKey : event.objectId,
                                         klCardIdKey : card.objectId}
                                block:^(id object, NSError *error) {
                                    
                                    if (!error) {
                                        completition(object, nil);
                                    } else {
                                        completition(nil, error);
                                    }
                                }];
}

- (void)buyTickets:(NSNumber *)ticketsCount
              card:(KLCard *)card
          forEvent:(KLEvent *)event
      completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klBuyTicketsClodeFunctionName
                       withParameters:@{ klPayValueKey : ticketsCount ,
                                         klInviteUserEventIdKey : event.objectId,
                                         klCardIdKey : card.objectId}
                                block:^(id object, NSError *error) {
                                    
                                    if (!error) {
                                        completition(object, nil);
                                    } else {
                                        completition(nil, error);
                                    }
                                }];
}

- (NSArray *)paymentsForEvent:(KLEvent *)event
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    NSMutableArray *result = [NSMutableArray array];
    if (event && event.price.isDataAvailable) {
        for (KLCharge *payment in event.price.payments) {
            if (![payment isEqual:[NSNull null]]
                && [payment isDataAvailable]
                && [payment.owner.objectId isEqualToString:currentUser.userObject.objectId]) {
                [result addObject:payment];
            }
        }
    }
    return result;
}

- (NSNumber *)boughtTicketsForEvent:(KLEvent *)event
{
    NSInteger sum = 0;
    for (KLCharge *payment in [self paymentsForEvent:event]) {
        sum += [payment.amount integerValue];
    }
    NSInteger pricePerPerson = [event.price.pricePerPerson integerValue];
    if (pricePerPerson) {
        return @(sum/pricePerPerson);
    } else {
        return @(0);
    }
}

- (NSNumber *)thrownInForEvent:(KLEvent *)event
{
    NSInteger sum = 0;
    for (KLCharge *payment in [self paymentsForEvent:event]) {
        sum += [payment.amount integerValue];
    }
    return @(sum);
}

- (void)topUser:(klCompletitionHandlerWithObject)completition
{
    PFQuery *query = [PFUser query];
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    query.limit = 10;
    NSArray *excludingIds = [KLAccountManager sharedManager].currentUser.following;
    excludingIds = [excludingIds arrayByAddingObjectsFromArray:@[currentUser.userObject.objectId]];
    [query whereKey:sf_key(objectId)
     notContainedIn:excludingIds];
    [query orderByDescending:sf_key(raiting)];
    [query whereKeyExists:sf_key(createdEvents)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFUser *user in objects) {
                if (((NSArray *)user[sf_key(createdEvents)]).count >= 3) {
                    completition(user, nil);
                    return;
                }
            }
            completition(nil, nil);
        }else {
            completition(nil, error);
        }
    }];
}

@end
