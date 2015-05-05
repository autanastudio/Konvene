//
//  KLEvent.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEvent.h"

@implementation KLEvent

@dynamic title;
@dynamic description;
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

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Event";
}

- (void)updateEventBackImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    [self kl_setObject:newImage forKey:sf_key(backImage)];
}

@end
