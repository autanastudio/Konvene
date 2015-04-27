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

- (void)getNearestPlace:(CLLocationCoordinate2D)location
             completion:(void (^)(KLLocation *place, NSError *error))completion;
- (void)getPlacesList:(NSString *)text
             location:(CLLocationCoordinate2D)location
           completion:(void (^)(NSArray *places, NSError *error))completion;

@end
