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

- (NSArray *)eventTypeEnumObjects
{
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
                           @"event_type",
                           @"event_drink",
                           @"event_tie",
                           @"event_bikini",
                           @"event_baloon",
                           @"event_ball",
                           @"event_sun",
                           @"event_globe",
                           @"event_food",
                           @"event_guitar",
                           @"event_trip",
                           @"event_coktail"];
    NSMutableArray *objects = [NSMutableArray array];
    for (NSUInteger i =0; i<KLEventTypeCount; i++) {
        KLEnumObject *object = [[KLEnumObject alloc] initWithEnumId:i
                                                               type:KLEnumTypeEventType
                                                           iconName:typeIcons[i]
                                                        descritpion:typeTitles[i]];
        [objects addObject:object];
    }
    return objects;
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

@end
