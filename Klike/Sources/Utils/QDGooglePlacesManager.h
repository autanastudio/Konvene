//
//  QDGooglePlacesManager.h
//  SocialEvents
//
//  Created by admin on 20/11/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLLocation.h"

@interface QDGooglePlacesManager : NSObject

+ (QDGooglePlacesManager *)sharedManager;

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


@end
