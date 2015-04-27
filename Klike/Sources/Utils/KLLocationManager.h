//
//  KLLocationManager.h
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLLocation.h"

@interface KLLocationManager : NSObject

+ (KLLocationManager *)sharedManager;

- (void)getNearestPlace:(CLLocationCoordinate2D)location
             completion:(void (^)(KLLocation *place, NSError *error))completion;
- (void)getPlacesList:(NSString *)text
             location:(CLLocationCoordinate2D)location
           completion:(void (^)(NSArray *places, NSError *error))completion;
- (void)getCities:(NSString *)text
         location:(CLLocationCoordinate2D)location
       completion:(void (^)(NSArray *places, NSError *error))completion;
- (void)fetchPlace:(KLLocation *)place
      completition:(void (^)(KLLocation *place, NSError *error))completition;

- (void)getCurrentPlaceWithLocation:(CLLocation *)location
                         completion:(void (^)(KLLocation *currentPlace))completition;

@end
