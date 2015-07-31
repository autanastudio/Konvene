//
//  KLEmailComposer.m
//  Klike
//
//  Created by Alexey on 7/30/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEmailComposer.h"

static NSString *klUserImagePlaceholderUrlId = @"16wvx3B";
static NSString *klEventImagePlaceholderUrlId = @"32RBU7j";

@implementation KLEmailComposer

+ (NSArray *)typeIcons
{
    return @[@"xFLmed1",
             @"IdsC5sO",
             @"BnWpLhC",
             @"JEat8jk",
             @"wWg7pa0",
             @"K4HQu5z",
             @"fr5EA7d",
             @"aFxgEe2",
             @"IOY8NMr",
             @"VCtaIur",
             @"PMtK5vo",
             @"sLiLEzm#1"];
}

+ (NSString *)typeStringWithEvent:(KLEvent *)event
{
    KLEnumObject *eventTypeObject = [[KLEventManager sharedManager] eventTypeObjectWithId:[event.eventType integerValue]];
    //Type none
    if (eventTypeObject.enumId==0) {
        return @"";
    }
    NSString *typeString = eventTypeObject.descriptionString;
    if (event.dresscode && event.dresscode.length>0) {
        typeString  = [typeString stringByAppendingString:[NSString stringWithFormat:@" / %@", event.dresscode]];
    }
    NSString *typeHTMLString = @"<p><img src=\"%@\" style=\"vertical-align:top; margin-right:6px;\" height=\"29\" width=\"20\"alt=\"Avatar\"> <span style=\"color:#b3b3bd; font-family:'Helvetica Neue', sans-serif;; font-size:22px; font-weight:normal;padding-right:20px;line-height:32px;\">%@</span></p>";
    NSString *typeIconUrlString = @"";
    NSArray *typeIcons = [KLEmailComposer typeIcons];
    if (eventTypeObject.enumId-1 < typeIcons.count) {
        typeIconUrlString = [KLEmailComposer getImguruUrl:typeIcons[eventTypeObject.enumId-1]];
    }
    return [NSString stringWithFormat:typeHTMLString, typeIconUrlString, typeString];
}

+ (NSString *)appendAttendees:(KLUserWrapper *)attende string:(NSString *)string
{
    NSString *htmlString = @"<img src=\"%@\" style=\"margin-right:16px; border-radius:50%@;\" alt=\"\" height=\"51\" width=\"50\">";
    NSString *fileString = [KLEmailComposer getImguruUrl:klUserImagePlaceholderUrlId];
    if (attende.userImage) {
        fileString = attende.userImage.url;
    }
    NSString *itemString = [NSString stringWithFormat:htmlString, fileString, @"%"];
    return [string stringByAppendingString:itemString];
}

+ (NSString *)getImguruUrl:(NSString *)imageId
{
    return [NSString stringWithFormat:@"http://i.imgur.com/%@.png", imageId];
}

+ (NSString *)emailBodyWithEvent:(KLEvent *)event file:(NSString *)htmlFileName
{
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"email_template" ofType:@"html"];
    NSString *emailBody = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    
    NSString *imageURLString = [KLEmailComposer getImguruUrl:klUserImagePlaceholderUrlId];
    if (user.userImage) {
        imageURLString = user.userImage.url;
    }
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~userImage~" withString:imageURLString];
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~userName~" withString:user.fullName];
    
    imageURLString = [KLEmailComposer getImguruUrl:klEventImagePlaceholderUrlId];
    if (event.backImage) {
        imageURLString = event.backImage.url;
    }
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventImage~" withString:imageURLString];
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventName~" withString:event.title];
    
    NSString *detailsStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                   localized:NO];
    if (event.location) {
        KLLocation *eventVenue = [[KLLocation alloc] initWithObject:event.location];
        detailsStr = [NSString stringWithFormat:@"%@ \U00002014 %@", detailsStr, eventVenue.name];
    }
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventDetails~" withString:detailsStr];
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventType~" withString:[KLEmailComposer typeStringWithEvent:event]];
    
    NSString *attendeesString = @"";
    NSArray *attendees = [[KLEventManager sharedManager].eventAttendeesCache objectForKey:event.objectId];
    if (attendees.count) {
        for (int i=0; i<attendees.count && i<6; i++) {
            KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:attendees[i]];
            attendeesString = [KLEmailComposer appendAttendees:userWrapper string:attendeesString];
        }
    }
    
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventAttendees~" withString:attendeesString];
    NSString *goingStr = @"";
    if (attendees.count>6) {
        goingStr = [NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
                    [NSString abbreviateNumber:attendees.count]];
    }
    emailBody = [emailBody stringByReplacingOccurrencesOfString:@"~EventGoing~" withString:goingStr];
    
    return emailBody;
}

@end
