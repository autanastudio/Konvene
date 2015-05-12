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
static NSString *klInviteUserInvitedIdKey = @"invitedId";
static NSString *klInviteUserEventIdKey = @"eventId";



@implementation KLLocalReminder

- (NSString*)eventObjectId
{
    return [self objectForKey:@"eventObjectId"];
}

- (void)setEventObjectId:(NSString *)eventObjectId
{
    [self setObject:eventObjectId forKey:@"eventObjectId"];
}

- (NSString*)remiderId
{
    return [self objectForKey:@"remiderId"];
}

- (void)setRemiderId:(NSString *)remiderId
{
    [self setObject:remiderId forKey:@"remiderId"];
}

- (KLEventReminderType)remiderType
{
    return [[self objectForKey:@"remiderType"] intValue];
}

- (void)setRemiderType:(KLEventReminderType)remiderType
{
    [self setObject:[NSNumber numberWithInt:remiderType] forKey:@"remiderType"];
}

+ (KLLocalReminder*)remiderFromDictionary:(NSDictionary *)dictionary
{
    KLLocalReminder *result = [[KLLocalReminder alloc] initWithDictionary:dictionary];
    return result;
}

+ (NSDate*)dateForEvenet:(KLEvent*)event forReminderType:(KLEventReminderType)type
{
    return event.startDate;
}

@end



@interface KLEventManager ()

@property (nonatomic, strong) NSArray *eventTypeObjects;
@property (nonatomic) NSMutableDictionary *eventInvitedUsers;

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
      completition:(klCompletitionHandlerWithObject)completition
{
    [PFCloud callFunctionInBackground:klInviteUserCloudeFunctionName
                       withParameters:@{ klInviteUserInvitedIdKey : user.userObject.objectId ,
                                         klInviteUserEventIdKey : event.objectId}
                                block:^(id object, NSError *error) {

                                    if (!_eventInvitedUsers)
                                        _eventInvitedUsers = [NSMutableDictionary dictionary];
                                    
                                    NSMutableArray *invitedUsers = [_eventInvitedUsers objectForKey:event.objectId];
                                    if (!invitedUsers)
                                    {
                                        invitedUsers = [NSMutableArray array];
                                        [_eventInvitedUsers setObject:invitedUsers forKey:event.objectId];
                                    }
                                    [invitedUsers addObject:user.userObject.objectId];
                                    
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
    
    NSMutableArray *array = [_eventInvitedUsers objectForKeyedSubscript:event.objectId];
    if (!array )
        return NO;
    
    return [array containsObject:user.userObject.objectId];
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
        [event.extension addUniqueObject:comment
                                  forKey:sf_key(comments)];
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                completition(YES, nil);
            } else {
                completition(NO, error);
            }
        }];
    } else {
        completition(NO, nil);
    }
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
    if (!user) {
        user = [KLAccountManager sharedManager].currentUser;
    }
    PFQuery *eventQuery = [KLEvent query];
    [eventQuery whereKey:sf_key(objectId)
                containedIn:user.createdEvents];
    return eventQuery;
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


- (void)addReminder:(KLEventReminderType)type toEvent:(KLEvent*)event
{
    EKEventStore *store = [[EKEventStore alloc] init ];
    
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        
        if (!granted)
            return;
        
        NSMutableArray *reminders = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"] mutableCopy];
        if (!reminders)
            reminders = [NSMutableArray array];
        
        NSCalendarUnit unit = NSCalendarUnitEra |
                            NSCalendarUnitYear  |
                            NSCalendarUnitMonth |
                            NSCalendarUnitDay   |
                            NSCalendarUnitHour  |
                            NSCalendarUnitMinute;

        EKReminder *reminder = [EKReminder reminderWithEventStore:store];
        reminder.calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:store];
        reminder.startDateComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:unit fromDate:event.startDate];
        reminder.dueDateComponents = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:unit fromDate:event.endDate];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[KLLocalReminder dateForEvenet:event forReminderType:type]];
        [reminder addAlarm:alarm];
        [store saveReminder:reminder commit:YES error:NULL];
        
        KLLocalReminder *localReminder = [KLLocalReminder new];
        localReminder.eventObjectId = event.objectId;
        localReminder.remiderType = type;
        localReminder.remiderId = reminder.calendarItemIdentifier;
        [reminders addObject:localReminder];
        
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    //
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
            
            [reminders removeObject:dictionary];
            break;
            
        }
    }
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

@end
