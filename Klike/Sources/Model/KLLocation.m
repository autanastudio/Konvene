//
//  KLLocation.m
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocation.h"

static NSString *klLocationKey = @"Location";

@implementation KLLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{sf_key(name) : @"name",
             sf_key(predictionDescription) : @"description",
             sf_key(latitude) : @"geometry.location.lat",
             sf_key(longitude) : @"geometry.location.lng",
             sf_key(address) : @"formatted_address",
             sf_key(placeId) : @"place_id",
             };
}

- (instancetype)init
{
    return [self initWithObject:[PFObject objectWithClassName:klLocationKey]];
}

- (instancetype)initWithObject:(PFObject *)object
{
    if (!object) {
        return nil;
    }
    if (self = [super init]) {
        self.locationObject = object;
    }
    return self;
}

- (NSString *)description
{
    if (self.predictionDescription) {
        return self.predictionDescription;
    } else {
        return self.name;
    }
}

- (NSNumber *)latitude
{
    return self.locationObject[sf_key(latitude)];
}

- (NSNumber *)longitude
{
    return self.locationObject[sf_key(longitude)];
}

- (NSString *)name
{
    return self.locationObject[sf_key(name)];
}

- (NSNumber *)custom
{
    return self.locationObject[sf_key(custom)];
}

- (NSString *)address
{
    return self.locationObject[sf_key(address)];
}

- (NSString *)placeId
{
    return self.locationObject[sf_key(placeId)];
}

- (void)setLatitude:(NSNumber *)latitude
{
    [self.locationObject kl_setObject:latitude
                            forKey:sf_key(latitude)];
}

- (void)setLongitude:(NSNumber *)longitude
{
    [self.locationObject kl_setObject:longitude
                            forKey:sf_key(longitude)];
}

- (void)setName:(NSString *)name
{
    [self.locationObject kl_setObject:name
                            forKey:sf_key(name)];
}

- (void)setCustom:(NSNumber *)custom
{
    [self.locationObject kl_setObject:custom
                            forKey:sf_key(custom)];
}

- (void)setAddress:(NSString *)address
{
    [self.locationObject kl_setObject:address
                               forKey:sf_key(address)];
}

- (void)setPlaceId:(NSString *)placeId
{
    [self.locationObject kl_setObject:placeId
                               forKey:sf_key(placeId)];
}

+ (PFQuery *)query
{
    return [PFQuery queryWithClassName:klLocationKey];
}

- (CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue]
                                      longitude:[self.longitude doubleValue]];
}

- (CLLocationDistance)distanceTo:(KLLocation *)toVenue
{
    CLLocation *locationFrom = [self location];
    CLLocation *locationTo = [toVenue location];
    return [locationFrom distanceFromLocation:locationTo];
}

@end
