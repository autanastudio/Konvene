//
//  KLUserWrapper.h
//  Klike
//
//  Created by admin on 12/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLForsquareVenue, KLVenmoInfo;

@interface KLUserWrapper : NSObject

@property (nonatomic, strong) PFUser *userObject;
@property (nonatomic, strong) NSNumber *isRegistered;
@property (nonatomic, strong) NSNumber *raiting;
@property (nonatomic, strong) NSNumber *invited;
@property (nonatomic, strong, readonly) NSNumber *isDeleted;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) KLVenmoInfo *venmoInfo;
@property (nonatomic, strong) NSString *stripeId;
@property (nonatomic, strong) PFFile *userImage;
@property (nonatomic, strong) PFFile *userImageThumbnail;
@property (nonatomic, strong) PFFile *userBackImage;
@property (nonatomic, strong) PFObject *place;
//@property (nonatomic, strong) KLUserPayment *paymentInfo;
@property (nonatomic, strong, readonly) NSArray *followers;
@property (nonatomic, strong, readonly) NSArray *following;
@property (nonatomic, strong, readonly) NSArray *createdEvents;

- (instancetype)initWithUserObject:(PFUser *)userObject;

- (void)updateUserImage:(UIImage *)image;
- (void)updateUserBackImage:(UIImage *)image;
- (NSString *)getInitials;
- (BOOL)isEqualToUser:(KLUserWrapper *)user;

@end
