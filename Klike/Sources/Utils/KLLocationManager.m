//
//  KLLocationManager.m
//  Klike
//
//  Created by admin on 27/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocationManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString * kGooglePlacesAPIKey = @"AIzaSyAT_diMModEArQG77s4lkcODkNG3J8iA7g";
static NSString * kGooglePlacesBaseUrl = @"https://maps.googleapis.com/maps/api/place/";
static NSString * kGooglePlacesNearbySearch = @"nearbysearch/json";
static NSString * kGooglePlacesTextSearch = @"textsearch/json";
static NSString * kGooglePlacesAutocomplete = @"autocomplete/json"; // Only autocomplete return cities
static NSString * kGooglePlacesDetails = @"details/json";

@interface KLLocationManager ()
@property(nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation KLLocationManager

+ (KLLocationManager *)sharedManager
{
    static KLLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *baseURL = [NSURL URLWithString:kGooglePlacesBaseUrl];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    }
    return self;
}

- (void)getNearestPlace:(CLLocationCoordinate2D)location
             completion:(void (^)(KLLocation *place, NSError *error))completion
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query sf_setObject:kGooglePlacesAPIKey forKey:@"key"];
    [query sf_setObject:[NSString stringWithFormat:@"%.7f,%.7f", location.latitude, location.longitude] forKey:@"location"];
    [query sf_setObject:@50000 forKey:@"radius"];
    
    [self.session GET:kGooglePlacesNearbySearch
           parameters:query
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSError *error;
                  NSArray *result = [MTLJSONAdapter modelsOfClass:[KLLocation class]
                                                    fromJSONArray:responseObject[@"results"]
                                                            error:&error];
                  if (!error) {
                      if (completion) {
                          completion(result.firstObject, nil);
                      }
                  } else {
                      if (completion) {
                          completion(nil, error);
                      }
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  if (completion) {
                      completion(nil, error);
                  }
              }];
}

- (void)getPlacesList:(NSString *)text
             location:(CLLocationCoordinate2D)location
           completion:(void (^)(NSArray *places, NSError *error))completion
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query sf_setObject:kGooglePlacesAPIKey forKey:@"key"];
    [query sf_setObject:text forKey:@"query"];
    if (location.longitude != 0 && location.latitude!=0) {
        [query sf_setObject:[NSString stringWithFormat:@"%.7f,%.7f", location.latitude, location.longitude]
                     forKey:@"location"];
        [query sf_setObject:@50000 forKey:@"radius"];
    }
    
    [self.session GET:kGooglePlacesTextSearch
           parameters:query
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSError *error;
                  NSArray *result = [MTLJSONAdapter modelsOfClass:[KLLocation class]
                                                    fromJSONArray:responseObject[@"results"]
                                                            error:&error];
                  if (!error) {
                      if (completion) {
                          completion(result, nil);
                      }
                  } else {
                      if (completion) {
                          completion(nil, error);
                      }
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  if (completion) {
                      completion(nil, error);
                  }
              }];
}

- (void)getCities:(NSString *)text
         location:(CLLocationCoordinate2D)location
       completion:(void (^)(NSArray *, NSError *))completion
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query sf_setObject:kGooglePlacesAPIKey forKey:@"key"];
    [query sf_setObject:text forKey:@"input"];
    [query sf_setObject:@"(cities)" forKey:@"types"];
    
    [self.session GET:kGooglePlacesAutocomplete
           parameters:query
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSError *error;
                  NSArray *result = [MTLJSONAdapter modelsOfClass:[KLLocation class]
                                                    fromJSONArray:responseObject[@"predictions"]
                                                            error:&error];
                  if (!error) {
                      if (completion) {
                          completion(result, nil);
                      }
                  } else {
                      if (completion) {
                          completion(nil, error);
                      }
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  if (completion) {
                      completion(nil, error);
                  }
              }];
}


- (void)fetchPlace:(KLLocation *)place
      completition:(void (^)(KLLocation *place, NSError *error))completition
{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query sf_setObject:kGooglePlacesAPIKey forKey:@"key"];
    [query sf_setObject:place.placeId forKey:@"placeid"];
    
    [self.session GET:kGooglePlacesDetails
           parameters:query
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSError *error;
                  KLLocation *result = [MTLJSONAdapter modelOfClass:[KLLocation class]
                                                 fromJSONDictionary:responseObject[@"result"]
                                                              error:&error];
                  if (!error) {
                      if (completition) {
                          completition(result, nil);
                      }
                  } else {
                      if (completition) {
                          completition(nil, error);
                      }
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  if (completition) {
                      completition(nil, error);
                  }
              }];
}

- (void)getCurrentPlaceWithLocation:(CLLocation *)location
                         completion:(void (^)(KLLocation *currentPlace))completition
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (!error) {
                           CLPlacemark *placemark = placemarks[0];
                           KLLocation *venue = [[KLLocation alloc] init];
                           venue.longitude = @(location.coordinate.longitude);
                           venue.latitude = @(location.coordinate.latitude);
                           venue.address = placemark.locality;
                           venue.name = placemark.name;
                           if (completition) {
                               completition(venue);
                           }
                       }
                   }];
}

@end
