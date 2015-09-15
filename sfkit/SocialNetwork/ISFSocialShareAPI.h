//
//  ISFSocialShareAPI.h
//  SocialEvents
//
//  Created by Дмитрий Александров on 10.09.14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ISFSocialShareAPI <NSObject>

- (void)postVideo:(NSData *)videoData message:(NSString *)message completion:(void (^)(NSError *error))completion;
- (void)postPhoto:(UIImage *)image message:(NSString *)message completion:(void (^)(NSError *error))completion;
- (void)postLink:(NSString *)link message:(NSString *)message comletion:(void (^)(NSError *error))completion;
- (void)postMessages:(NSString *)message completion:(void (^)(NSError *error))completion;

@end

