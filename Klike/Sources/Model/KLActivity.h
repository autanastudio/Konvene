//
//  KLActivity.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

typedef enum : NSUInteger {
    KLActivityTypeFollowMe,
    KLActivityTypeFollow,
    KLActivityTypeCreateEvent,
    KLActivityTypeGoesToEvent,
    KLActivityTypeGoesToMyEvent,
    KLActivityTypeEventCanceled,
    KLActivityTypeEventChangedName,
    KLActivityTypeEventChangedLocation,
    KLActivityTypeEventChangedTime,
    KLActivityTypePhotosAdded,
    KLActivityTypeCommentAdded,
    KLActivityTypePayForEvent,
    KLActivityTypeCommentAddedToAttendedEvent
} KLActivityType;


@interface KLActivity : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber *activityType;
@property (nonatomic, strong) PFUser *from;
@property (nonatomic, strong) KLEvent *event;
@property (nonatomic, strong) NSString *deletedEventTitle;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *observers;

@end
