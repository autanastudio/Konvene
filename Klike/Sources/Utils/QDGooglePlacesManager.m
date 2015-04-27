//
//  QDGooglePlacesManager.m
//  SocialEvents
//
//  Created by admin on 20/11/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "QDGooglePlacesManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString * kGooglePlacesAPIKey = @"AIzaSyDG-w_uvyRDVKbWA4s9i9V3eEUEMuebVok";
static NSString * kGooglePlacesBaseUrl = @"https://maps.googleapis.com/maps/api/place/";
static NSString * kGooglePlacesNearbySearch = @"nearbysearch/json";
static NSString * kGooglePlacesTextSearch = @"textsearch/json";

@interface QDGooglePlacesManager ()
@property(nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation QDGooglePlacesManager

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
    [query sf_setObject:[NSString stringWithFormat:@"%.7f,%.7f", location.latitude, location.longitude]
                 forKey:@"location"];
    [query sf_setObject:@50000 forKey:@"radius"];
    
    [self.session GET:kGooglePlacesTextSearch
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

@end
