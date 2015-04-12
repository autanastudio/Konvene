//
//  KLEnumObject.m
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEnumObject.h"

@implementation KLEnumObject

- (instancetype)initWithEnumId:(NSUInteger)enumId
                          type:(KLEnumType)type
                      iconName:(NSString *)iconName
                   descritpion:(NSString *)description
         additionalDescription:(NSString *)additionaldescription
{
    if (self = [super init]) {
        self.enumId = enumId;
        self.type = type;
        self.iconNameString = iconName;
        self.descriptionString = description;
        self.additionalDescriptionString = additionaldescription;
    }
    return self;
}

- (instancetype)initWithEnumId:(NSUInteger)enumId
                          type:(KLEnumType)type
                      iconName:(NSString *)iconName
                   descritpion:(NSString *)description
{
    return [self initWithEnumId:enumId
                           type:type
                       iconName:iconName
                    descritpion:description
          additionalDescription:nil];
}

- (NSString *)description
{
    return self.descriptionString;
}

- (BOOL)isEqual:(id)object
{
    KLEnumObject *otherObject = (KLEnumObject *)object;
    return self.type==otherObject.type && self.enumId==otherObject.enumId;
}

@end
