//
//  KLLoginManager.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginManager.h"
#import "KLAccountManager.h"

@interface KLLoginManager ()

@end

static NSString *klRequestCodeCloudeFunctionName = @"requestCode";
static NSString *klAuthorizeCloudeFunctionName = @"authorize";

static NSString *klUserPhoneNumberKey = @"phoneNumber";
static NSString *klUserVerificationCodeKey = @"verificationCode";

static NSString *klDefaultCountryCode = @"+1";

@implementation KLLoginManager

+ (instancetype)sharedManager {
    static KLLoginManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.countryCode = klDefaultCountryCode;
        self.phoneNumber = nil;
        self.verificationCode = nil;
    }
    return self;
}

- (void)requestAuthorizationWithHandler:(void (^)(BOOL success, NSError *error))completiotion
{
    [self requestAuthorizationWithPhoneNumber:self.phoneNumber
                                      handler:completiotion];
}

- (void)authorizeUserWithHandler:(void (^)(PFUser *user, NSError *error))completiotion
{
    [self authorizeUserWithPhoneNumber:self.phoneNumber
                      verificationCode:self.verificationCode
                               handler:completiotion];
}

- (void)requestAuthorizationWithPhoneNumber:(NSString *)phoneNumber
                                    handler:(void (^)(BOOL, NSError *))completiotion
{
    [PFCloud callFunctionInBackground:klRequestCodeCloudeFunctionName
                       withParameters:@{ klUserPhoneNumberKey : phoneNumber }
                                block:^(id object, NSError *error) {
                                    completiotion(!error, error);
                                }];
}

- (void)authorizeUserWithPhoneNumber:(NSString *)phoneNumber
                    verificationCode:(NSString *)code
                             handler:(void (^)(PFUser *, NSError *))completiotion
{
    [PFCloud callFunctionInBackground:klAuthorizeCloudeFunctionName
                       withParameters:@{ klUserPhoneNumberKey : phoneNumber,
                                         klUserVerificationCodeKey : code}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        [PFUser becomeInBackground:@"" block:^(PFUser *user, NSError *error) {
                                            if (!error) {
                                                [KLAccountManager sharedManager].currentUser = user;
                                                completiotion(user, nil);
                                            } else {
                                                completiotion(nil, error);
                                            }
                                        }];
                                    } else {
                                        completiotion(nil, error);
                                    }
                                }];
}

@end
