//
//  KLForsquareVenue.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLForsquareVenue : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *custom;
@property (nonatomic, strong) PFObject *venueObject;

- (instancetype)initWithObject:(PFObject *)object;

@end
