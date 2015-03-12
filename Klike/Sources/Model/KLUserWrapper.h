//
//  KLUserWrapper.h
//  Klike
//
//  Created by admin on 12/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLUserWrapper : NSObject

@property (nonatomic, strong) PFUser *userObject;
@property (nonatomic, strong) NSNumber *isRegistered;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) PFFile *userImage;
@property (nonatomic, strong) PFFile *userBackImage;
//TODO add geolocation

- (instancetype)initWithUserObject:(PFUser *)userObject;

- (void)updateUserImage:(UIImage *)image;
- (void)updateUserBaackImage:(UIImage *)image;

@end
