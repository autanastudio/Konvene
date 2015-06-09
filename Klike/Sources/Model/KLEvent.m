//
//  KLEvent.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEvent.h"

static NSString *klEventClassName = @"Event";

@implementation KLEvent

@dynamic title;
@dynamic descriptionText;
@dynamic startDate;
@dynamic endDate;
@dynamic location;
@dynamic privacy;
@dynamic eventType;
@dynamic dresscode;
@dynamic backImage;
@dynamic owner;
@dynamic attendees;
@dynamic invited;
@dynamic extension;
@dynamic price;
@dynamic savers;
@dynamic hide;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klEventClassName;
}

+ (KLEvent *)eventWithoutDataWithId:(NSString *)objectId
{
    return [KLEvent objectWithoutDataWithClassName:klEventClassName
                                          objectId:objectId];
}

- (KLEventExtension *)extension
{
    KLEventExtension *extension = self[sf_key(extension)];
    if(!extension) {
        extension = [KLEventExtension object];
        [self kl_setObject:extension forKey:sf_key(extension)];
    }
    return extension;
}

- (KLEventPrice *)price
{
    KLEventPrice *price = self[sf_key(price)];
    if (!price) {
        price = [KLEventPrice object];
        [self kl_setObject:price forKey:sf_key(price)];
    }
    return price;
}

- (void)updateEventBackImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    [self kl_setObject:newImage forKey:sf_key(backImage)];
}

- (NSArray *)attendees
{
    if (!self[sf_key(attendees)]) {
        return [NSArray array];
    } else {
        return self[sf_key(attendees)];
    }
}

- (NSArray *)invited
{
    if (!self[sf_key(invited)]) {
        return [NSArray array];
    } else {
        return self[sf_key(invited)];
    }
}

- (BOOL)isPastEvent
{
    NSDate *today = [NSDate date];
    if (self.endDate) {
        return [self.endDate mt_hoursUntilDate:today] > 12;
    } else {
        return [self.startDate mt_hoursUntilDate:today] > 12;
    }
}

- (BOOL)isOwner:(KLUserWrapper *)user
{
    KLUserWrapper *owner = [[KLUserWrapper alloc] initWithUserObject:self.owner];
    return [user isEqualToUser:owner];
}

@end
