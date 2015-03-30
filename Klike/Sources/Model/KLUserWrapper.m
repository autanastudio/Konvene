//
//  KLUserWrapper.m
//  Klike
//
//  Created by admin on 12/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserWrapper.h"
#import "KLForsquareVenue.h"

@implementation KLUserWrapper

static NSString *klUserKeyImage = @"userImage";
static NSString *klUserKeyBackImage = @"userBackImage";
static NSString *klUserKeyisRegistered = @"isRegistered";
static NSString *klUserKeyFullName = @"fullName";
static NSString *klUserKeyPhone = @"phoneNumber";
static NSString *klUserKeyPlace = @"place";
static NSString *klUserKeyFollowerCount = @"followerCount";
static NSString *klUserKeyFollowingCount = @"followingCount";

- (instancetype)initWithUserObject:(PFUser *)userObject
{
    if (self = [super init]) {
        self.userObject = userObject;
    }
    return self;
}

- (void)updateUserImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    self.userObject[klUserKeyImage] = newImage;
}

- (void)updateUserBackImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    self.userObject[klUserKeyBackImage] = newImage;
}

- (void)setFullName:(NSString *)fullName
{
    if (fullName) {
        self.userObject[klUserKeyFullName] = fullName;
    }
}

- (void)setIsRegistered:(NSNumber *)isRegistered
{
    if (isRegistered) {
        self.userObject[klUserKeyisRegistered] = isRegistered;
    } else {
        self.userObject[klUserKeyisRegistered] = @(NO);
    }
}

- (NSString *)fullName
{
    return self.userObject[klUserKeyFullName];
}

- (PFFile *)userImage
{
    return self.userObject[klUserKeyImage];
}

- (NSNumber *)isRegistered
{
    return self.userObject[klUserKeyisRegistered];
}

@end
