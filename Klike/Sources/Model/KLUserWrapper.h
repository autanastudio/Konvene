//
//  KLUserWrapper.h
//  Klike
//
//  Created by admin on 12/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLForsquareVenue;

@interface KLUserWrapper : NSObject

@property (nonatomic, strong) PFUser *userObject;
@property (nonatomic, strong) NSNumber *isRegistered;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) PFFile *userImage;
@property (nonatomic, strong) PFFile *userBackImage;
@property (nonatomic, strong) KLForsquareVenue *place;
@property (nonatomic, strong, readonly) NSNumber *followerCount;
@property (nonatomic, strong, readonly) NSNumber *followingCount;

- (instancetype)initWithUserObject:(PFUser *)userObject;

- (void)updateUserImage:(UIImage *)image;
- (void)updateUserBackImage:(UIImage *)image;

@end
