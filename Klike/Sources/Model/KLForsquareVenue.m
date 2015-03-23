//
//  KLForsquareVenue.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLForsquareVenue.h"

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

@end
