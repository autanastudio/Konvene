//
//  SFFacebookAPI.m
//  SFKit
//
//  Created by Yarik Smirnov on 28/06/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFFacebookAPI.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SFExtensions.h"

@import AVFoundation;
@interface SFFacebookAPI ()
+ (BOOL)isPublishPermission:(NSString *)permission;
+ (BOOL)areAllPermissionsReadPermissions:(NSArray *)permissions;
@end

//Absolutly no need for FBSession to retain that handler.
//This approach show itself to have a lot of sideeffects.
@interface FBSession ()
@property (nonatomic, copy) FBSessionStateHandler loginHandler;
@end

@implementation SFFacebookAPI

+ (SFSocialService)socialServiceType
{
    return SFSocialServiceFacebook;
}

- (void)loadCachedAuthorizationForScope:(NSArray *)scope
{
    __weak typeof(self) weakSelf = self;
    if ([self.class areAllPermissionsReadPermissions:scope]) {
        [FBSession openActiveSessionWithReadPermissions:scope
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [weakSelf sessionStateDidChange:status error:error];
                                      }];
    } else {
        [FBSession openActiveSessionWithPublishPermissions:scope
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:NO
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             [weakSelf sessionStateDidChange:status error:error];
                                         }];
    }
}

- (void)requestAuthorizationForScope:(NSArray *)scope completion:(SFSocialAuthorizationHandler)handler
{
    __weak typeof(self) weakSelf = self;
    if ([self.class areAllPermissionsReadPermissions:scope]) {
        [FBSession.activeSession requestNewReadPermissions:scope
                                         completionHandler:^(FBSession *session, NSError *error) {
                                             [weakSelf sessionStateDidChange:session.state error:error];
                                             if (handler && session.state != FBSessionStateClosed) {
                                                 handler(session.state == FBSessionStateOpenTokenExtended, error);
                                             }
                                         }];
    } else {
        [FBSession.activeSession requestNewPublishPermissions:scope
                                              defaultAudience:FBSessionDefaultAudienceEveryone
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                [weakSelf sessionStateDidChange:session.state error:error];
                                                if (handler && session.state != FBSessionStateClosed) {
                                                    handler(session.state == FBSessionStateOpenTokenExtended, error);
                                                }
                                            }];
    }
}

- (void)isAuthorizedForScope:(NSArray *)scope completionHandler:(void (^)(BOOL, NSError *))handler
{
    [FBSession.activeSession refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
        BOOL isAuthorized = NO;
        for (NSString *permission in scope) {
            isAuthorized = [FBSession.activeSession hasGranted:permission];
            if (!isAuthorized) {
                break;
            }
        }
        if (handler) {
            handler(isAuthorized, error);
        }
    }];
}

- (void)openSession:(SFSocialAuthorizationHandler)completion
{
    [self openSessionForScope:nil completion:completion];
}

- (void)openSessionForScope:(NSArray *)scope completion:(SFSocialAuthorizationHandler)handler
{
    __weak typeof(self) weakSelf = self;
    // If scope does not matter we must specify "public_profile" at least
    if (scope.count == 0) {
        scope = @[@"public_profile"];
    }
    if ([self.class areAllPermissionsReadPermissions:scope]) {
        [FBSession openActiveSessionWithReadPermissions:scope
                                           allowLoginUI:YES 
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [weakSelf sessionStateDidChange:status error:error];
                                          if (handler && status != FBSessionStateClosed) {
                                              handler(FB_ISSESSIONOPENWITHSTATE(status), error);
                                          }
                                      }];
    } else {
        [FBSession openActiveSessionWithPublishPermissions:scope
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             [weakSelf sessionStateDidChange:status error:error];
                                             if (handler && status != FBSessionStateClosed) {
                                                 handler(FB_ISSESSIONOPENWITHSTATE(status), error);
                                             }
                                         }];
    }
}


- (BOOL)isAuthorized
{
    return FBSession.activeSession.isOpen;
}

- (BOOL)handleOpenURL:(NSURL *)openURL sourceApp:(NSString *)appID
{
    return [FBAppCall handleOpenURL:openURL sourceApplication:appID];
}

- (void)handleAppBecomeActive
{
    [FBAppCall handleDidBecomeActive];
}

- (void)closeSessionAndClearAccessData
{
    FBSession.activeSession.loginHandler = nil;
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
}

- (void)closeSession
{
    [FBSession.activeSession close];
}

- (void)getAuthorizationParams:(SFSocialAuthorizationParamsHandler)completion
{
    NSMutableDictionary *authorizationParams = [NSMutableDictionary dictionary];
    [authorizationParams sf_setObject:@"facebook" forKey:@"type"];
    [authorizationParams sf_setObject:FBSession.activeSession.accessTokenData.accessToken
                               forKey:@"facebook_token"];
    if (completion) {
        completion(authorizationParams, nil);
    }
}

- (void)sessionStateDidChange:(FBSessionState)state error:(NSError *)error
{
    if (error) {
        NSLog(@"Facebook Authorization Error: %@", error);
        [self closeSessionAndClearAccessData];
    }
    if (self.stateHandler) {
        self.stateHandler(state, error);
    }
}

#pragma mark - SocialProfile methods

//- (void)getSocialProfile:(void (^)(SFUser *, NSError *))completion
//{
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        NSError *innerError = error;
//        SFUser *profile = nil;
//        if (!innerError) {
//            profile = [MTLJSONAdapter modelOfClass:[SFUser class] fromJSONDictionary:result error:&innerError];
//        }
//        if (completion) {
//            completion(profile, innerError);
//        }
//    }];
//}

- (void)getProfilePictureWithSize:(CGSize)size completion:(void (^)(UIImage *, NSError *))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params sf_setObject:@"square" forKey:@"type"];
    CGFloat displayScale = [UIScreen mainScreen].scale;
    [params sf_setObject:@(size.width * displayScale).description forKey:@"width"];
    [params sf_setObject:@(size.height * displayScale).description forKey:@"height"];
    FBRequest *pictureReuqest = [FBRequest requestWithGraphPath:@"me/picture"
                                                     parameters:params
                                                     HTTPMethod:@"GET"];
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:pictureReuqest completionHandler:NULL];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:connection.urlRequest
                                                                 completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data.length > 0 && completion && !error) {
                                          UIImage *image = [UIImage imageWithData:data];
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completion(image, error);
                                          });
                                      } else if (completion) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              completion(nil, error);
                                          });
                                      }
                                  }];
    [task resume];
}

#pragma mark - SocialShare methods

- (void)postVideo:(NSData *)videoData message:(NSString *)message completion:(void (^)(NSError *))completion
{
    //TODO: Implement video uploading to Facebook
}

- (void)postPhoto:(UIImage *)image message:(NSString *)message completion:(void (^)(NSError *))completion
{
    NSData *jpegData = UIImageJPEGRepresentation(image, 1);
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params sf_setObject:jpegData forKey:@"source"];
    [params sf_setObject:message forKey:@"message"];
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (completion) {
                                  completion(error);
                              }
                          }];
}

- (void)postLink:(NSString *)link message:(NSString *)message comletion:(void (^)(NSError *))completion
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params sf_setObject:message forKey:@"message"];
    [params sf_setObject:link forKey:@"link"];
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (completion) {
                                  completion(error);
                              }
                          }];
}

- (void)postMessages:(NSString *)message completion:(void (^)(NSError *))completion
{
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (completion) {
                                        completion(error);
                                    }
                                }];
}


- (void)share:(NSString *)content
        image:(UIImage *)image
        title:(NSString *)title
         link:(NSString *)link
     dialogue:(BOOL)isDialog
viewController:(UIViewController *)vc
completion:(void (^)(NSError *))completionHandler
{
    if(isDialog){
        if([FBDialogs canPresentOSIntegratedShareDialog]){
            [FBDialogs presentOSIntegratedShareDialogModallyFrom:vc
                                                     initialText:nil
                                                           image:image
                                                             url:[NSURL URLWithString:link]
                                                         handler:^(FBOSIntegratedShareDialogResult result,
                                                                   NSError *error) {
                                                             completionHandler(error);
                                                         }];
            return;
        }
    }
    void (^ publishBlock)() = ^{
        
    };
    NSData *jpegData = UIImageJPEGRepresentation(image, 1.0);
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:jpegData forKey:@"source"];
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error) {
                                  completionHandler(nil);
                              }
                              else {
                                  completionHandler(error);
                              }
                          }];
}

#pragma mark - FBUtility Private

+ (BOOL)isPublishPermission:(NSString *)permission {
    return [permission hasPrefix:@"publish"] ||
    [permission hasPrefix:@"manage"] ||
    [permission isEqualToString:@"ads_management"] ||
    [permission isEqualToString:@"create_event"] ||
    [permission isEqualToString:@"rsvp_event"];
}

+ (BOOL)areAllPermissionsReadPermissions:(NSArray *)permissions {
    for (NSString *permission in permissions) {
        if ([self isPublishPermission:permission]) {
            return NO;
        }
    }
    return YES;
}


@end
