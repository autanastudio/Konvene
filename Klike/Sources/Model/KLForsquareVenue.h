//
//  KLForsquareVenue.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLForsquareVenue : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL custom;

@end
