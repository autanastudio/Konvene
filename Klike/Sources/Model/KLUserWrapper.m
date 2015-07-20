//
//  KLUserWrapper.m
//  Klike
//
//  Created by admin on 12/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserWrapper.h"
#import "KLLocation.h"

@implementation KLUserWrapper

- (instancetype)initWithUserObject:(PFUser *)userObject
{
    if (self = [super init]) {
        if ([userObject isEqual:[NSNull null]]) {
            self.userObject = nil;
        } else {
            self.userObject = userObject;
        }
    }
    return self;
}

- (void)updateUserImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    [self.userObject kl_setObject:newImage
                           forKey:sf_key(userImage)];
}

- (void)updateUserBackImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *newImage = [PFFile fileWithData:imageData];
    [self.userObject kl_setObject:newImage
                           forKey:sf_key(userBackImage)];
}

- (NSString *)getInitials
{
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [self.fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger i = 0;
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
            i++;
        }
        if (i==2) {
            break;
        }
    }
    return firstCharacters;
}

- (BOOL)isEqualToUser:(KLUserWrapper *)user
{
    return [self.userObject.objectId isEqualToString:user.userObject.objectId];
}

- (void)setRaiting:(NSNumber *)raiting
{
    [self.userObject kl_setObject:raiting
                           forKey:sf_key(raiting)];
}

- (void)setInvited:(NSNumber *)invited
{
    [self.userObject kl_setObject:invited
                           forKey:sf_key(invited)];
}

- (void)setFullName:(NSString *)fullName
{
    [self.userObject kl_setObject:fullName
                           forKey:sf_key(fullName)];
}

- (void)setIsRegistered:(NSNumber *)isRegistered
{
    [self.userObject kl_setObject:isRegistered
                           forKey:sf_key(isRegistered)];
}

- (void)setPlace:(PFObject *)place
{
    [self.userObject kl_setObject:place
                           forKey:sf_key(place)];
}

- (void)setStripeId:(NSString *)stripeId
{
    [self.userObject kl_setObject:stripeId
                           forKey:sf_key(stripeId)];
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    [self.userObject kl_setObject:phoneNumber
                           forKey:sf_key(phoneNumber)];
}

- (void)setPaymentInfo:(KLUserPayment *)paymentInfo
{
    [self.userObject kl_setObject:paymentInfo
                           forKey:sf_key(paymentInfo)];
}

- (NSString *)fullName
{
    return self.userObject[sf_key(fullName)];
}

- (PFFile *)userImage
{
    return self.userObject[sf_key(userImage)];
}

- (PFFile *)userImageThumbnail
{
    if ([self.userObject isEqual:[NSNull null]]) {
        return nil;
    }
    PFFile *temp = self.userObject[sf_key(userImageThumbnail)];
    if (temp) {
        return temp;
    } else {
        return self.userImage;
    }
}

- (PFFile *)userBackImage
{
    if ([self.userObject isEqual:[NSNull null]]) {
        return nil;
    }
    return self.userObject[sf_key(userBackImage)];
}

- (NSNumber *)isRegistered
{
    return self.userObject[sf_key(isRegistered)];
}

- (NSNumber *)invited
{
    return self.userObject[sf_key(invited)];
}

- (PFObject *)place
{
    return self.userObject[sf_key(place)];
}

- (NSString *)stripeId
{
    return self.userObject[sf_key(stripeId)];
}

- (NSArray *)followers
{
    if (!self.userObject[sf_key(followers)]) {
        return [NSArray array];
    } else {
        return self.userObject[sf_key(followers)];
    }
}

- (NSArray *)following
{
    if (!self.userObject[sf_key(following)]) {
        return [NSArray array];
    } else {
        return self.userObject[sf_key(following)];
    }
}

- (NSNumber *)isDeleted
{
    return self.userObject[sf_key(isDeleted)];
}

- (NSArray *)createdEvents
{
    if (!self.userObject[sf_key(createdEvents)]) {
        return [NSArray array];
    } else {
        return self.userObject[sf_key(createdEvents)];
    }
}

- (NSString *)phoneNumber
{
    return self.userObject[sf_key(phoneNumber)];
}

- (KLUserPayment *)paymentInfo
{
    return self.userObject[sf_key(paymentInfo)];
}

-(NSNumber *)raiting
{
    return self.userObject[sf_key(raiting)];
}

@end
