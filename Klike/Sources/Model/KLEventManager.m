//
//  KLEventManager.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventManager.h"

static NSString *klInviteUserCloudeFunctionName = @"invite";
static NSString *klInviteUserInvitedIdKey = @"invitedId";
static NSString *klInviteUserEventIdKey = @"eventId";

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
           toServer:(klAccountCompletitionHandler)completition
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
        if ([event.invited indexOfObject:follingId]!=NSNotFound) { //TODO replace with attendies
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
    [query whereKey:sf_key(objectId) containedIn:event.invited];//TODO replace with attendies
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completition(objects, error);
    }];
}

@end
