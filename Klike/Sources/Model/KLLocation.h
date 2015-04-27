//
//  KLLocation.h
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLLocation : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *custom;
@property (nonatomic, strong) PFObject *locationObject;

- (instancetype)initWithObject:(PFObject *)object;
- (CLLocation *)location;
- (CLLocationDistance)distanceTo:(KLLocation *)toVenue;
+ (PFQuery *)query;

@end
