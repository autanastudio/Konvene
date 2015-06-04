//
//  KLVenmoAuthController.h
//  Klike
//
//  Created by Alexey on 6/4/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLVenmoAuthController;

@protocol KLVenmoDelegate <NSObject>

@optional
- (void)oAuthViewController:(KLVenmoAuthController *)viewController
         didSucceedWithUser:(PFUser *)user;
- (void)oAuthViewController:(KLVenmoAuthController *)viewController
           didFailWithError:(NSError *)error;

@end

@interface KLVenmoAuthController : KLViewController <UIWebViewDelegate>

@property (nonatomic,assign) id<KLVenmoDelegate> delegate;

/**
 Init view controller
 
 @param baseURL         the api's base url (e.g. https://googleapis.com/ )
 @param authPath        path for authorization request
 @param clientID        OAuth2 client id
 @param scope           Requested scope (e.g. "read" or "read+write")
 @param redirectURL     url where the user is redirected after authorization
 */
- (id)initWithBaseURL:(NSString *)baseURL
   authenticationPath:(NSString *)authPath
             clientID:(NSString *)clientID
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL;

/*
 * Load the authorization page
 */
- (void)authorize;

@end
