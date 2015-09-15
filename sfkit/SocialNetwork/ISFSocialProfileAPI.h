//
//  ISFSocialProfile.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 20/08/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISFSocialProfileAPI <NSObject>

//- (void)getSocialProfile:(void (^)(SFUser *profile, NSError *error))completion;

- (void)getProfilePictureWithSize:(CGSize)size completion:(void (^)(UIImage *image, NSError *error))completion;

@end
