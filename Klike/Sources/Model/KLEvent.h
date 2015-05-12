//
//  KLEvent.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>



typedef enum : NSUInteger {
    KLEventTypeNone,
    KLEventTypeBirthday,
    KLEventTypeGetTogether,
    KLEventTypeMeeting,
    KLEventTypePoolParty,
    KLEventTypeHoliday,
    KLEventTypePreGame,
    KLEventTypeDayParty,
    KLEventTypeStudySession,
    KLEventTypeEatinOut,
    KLEventTypeMusicEvent,
    KLEventTypeTrip,
    KLEventTypeParty,
    KLEventTypeCount
} KLEventType;



typedef enum : NSUInteger {
    KLEventPrivacyTypePublic,
    KLEventPrivacyTypePrivate,
    KLEventPrivacyTypePrivatePlus,
    KLEventPrivacyTypeCount
} KLEventPrivacyType;



typedef enum : NSUInteger {
    KLEventReminderTypeInTime,
    KLEventReminderType5m,
    KLEventReminderType15m,
    KLEventReminderType30m,
    KLEventReminderType1h,
    KLEventReminderType2h,
    KLEventReminderType1d,
    KLEventReminderType2d,
} KLEventReminderType;



@interface KLEvent : PFObject <PFSubclassing>

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *descriptionText;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, strong) PFObject *location;
@property(nonatomic, strong) NSNumber *privacy;
@property(nonatomic, strong) NSNumber *eventType;
@property(nonatomic, strong) NSString *dresscode;
@property(nonatomic, strong) PFFile *backImage;
@property(nonatomic, strong) PFUser *owner;
@property(nonatomic, strong) NSArray *attendees;
@property(nonatomic, strong) NSArray *invited;
@property(nonatomic, strong) KLEventExtension *extension;
@property(nonatomic, strong) KLEventPrice *price;

+ (NSString *)parseClassName;
+ (KLEvent *)eventWithoutDataWithId:(NSString *)objectId;
- (void)updateEventBackImage:(UIImage *)image;

@end
