//
//  KLLoginManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLLoginManager : NSObject

@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSString *verificationCode;

+ (instancetype)sharedManager;

- (void)requestAuthorizationWithHandler:(void (^)(BOOL success, NSError *error))completiotion;
- (void)authorizeUserWithHandler:(void (^)(PFUser *user, NSError *error))completiotion;
- (void)requestAuthorizationWithPhoneNumber:(NSString *)phoneNumber
                                    handler:(void (^)(BOOL success, NSError *error))completiotion;
- (void)authorizeUserWithPhoneNumber:(NSString *)phoneNumber
                    verificationCode:(NSString *)code
                             handler:(void (^)(PFUser *user, NSError *error))completiotion;
- (NSString *)getFullPhoneNumberString;

@end
