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
        self.userObject = userObject;
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

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    [self.userObject kl_setObject:phoneNumber
                           forKey:sf_key(phoneNumber)];
}

- (NSString *)fullName
{
    return self.userObject[sf_key(fullName)];
}

- (PFFile *)userImage
{
    return self.userObject[sf_key(userImage)];
}

- (NSNumber *)isRegistered
{
    return self.userObject[sf_key(isRegistered)];
}

- (PFObject *)place
{
    return self.userObject[sf_key(place)];
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

@end
