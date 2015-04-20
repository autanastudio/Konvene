//
//  KLForsquareVenue.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLForsquareVenue.h"

static NSString *klForsquareVenueKey = @"ForsquareVenue";

@implementation KLForsquareVenue

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{sf_key(name) : @"name",
             sf_key(latitude) : @"location.lat",
             sf_key(longitude) : @"location.lng",
             sf_key(city) : @"location.city",
             sf_key(state) : @"location.state"
             };
}

- (instancetype)init
{
    return [self initWithObject:[PFObject objectWithClassName:klForsquareVenueKey]];
}

- (instancetype)initWithObject:(PFObject *)object
{
    if (self = [super init]) {
        self.venueObject = object;
    }
    return self;
}

- (NSString *)description
{
    return self.name;
}

- (NSNumber *)latitude
{
    return self.venueObject[sf_key(latitude)];
}

- (NSNumber *)longitude
{
    return self.venueObject[sf_key(longitude)];
}

- (NSString *)city
{
    return self.venueObject[sf_key(city)];
}

- (NSString *)state
{
    return self.venueObject[sf_key(state)];
}

- (NSString *)name
{
    return self.venueObject[sf_key(name)];
}

- (NSNumber *)custom
{
    return self.venueObject[sf_key(custom)];
}

- (void)setLatitude:(NSNumber *)latitude
{
    [self.venueObject kl_setObject:latitude
                            forKey:sf_key(latitude)];
}

- (void)setLongitude:(NSNumber *)longitude
{
    [self.venueObject kl_setObject:longitude
                            forKey:sf_key(longitude)];
}

- (void)setState:(NSString *)state
{
    [self.venueObject kl_setObject:state
                            forKey:sf_key(state)];
}

- (void)setCity:(NSString *)city
{
    [self.venueObject kl_setObject:city
                            forKey:sf_key(city)];
}

- (void)setName:(NSString *)name
{
    [self.venueObject kl_setObject:name
                            forKey:sf_key(name)];
}

- (void)setCustom:(NSNumber *)custom
{
    [self.venueObject kl_setObject:custom
                            forKey:sf_key(custom)];
}

+ (PFQuery *)query
{
    return [PFQuery queryWithClassName:klForsquareVenueKey];
}

- (CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue]
                                      longitude:[self.longitude doubleValue]];
}

- (CLLocationDistance)distanceTo:(KLForsquareVenue *)toVenue
{
    CLLocation *locationFrom = [self location];
    CLLocation *locationTo = [toVenue location];
    return [locationFrom distanceFromLocation:locationTo];
}

@end
