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
@dynamic pricingType;
@dynamic pricePerPerson;
@dynamic minimumAmount;
@dynamic suggestedAmount;
@dynamic backImage;
@dynamic owner;
@dynamic maximumTickets;
@dynamic attendees;
@dynamic invited;
@dynamic throwIn;
@dynamic soldTickets;
@dynamic extension;

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

- (void)updateEventBackImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    [self kl_setObject:newImage forKey:sf_key(backImage)];
}

@end
