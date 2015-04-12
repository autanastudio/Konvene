//
//  KLEnumObject.h
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KLEnumTypeEventType,
    KLEnumTypePrivacy,
} KLEnumType;

@interface KLEnumObject : NSObject

@property (nonatomic, assign) NSUInteger enumId;
@property (nonatomic, assign) KLEnumType type;
@property (nonatomic, strong) NSString *iconNameString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSString *additionalDescriptionString;

- (instancetype)initWithEnumId:(NSUInteger)enumId
                          type:(KLEnumType)type
                      iconName:(NSString *)iconName
                   descritpion:(NSString *)description
         additionalDescription:(NSString *)additionaldescription;

- (instancetype)initWithEnumId:(NSUInteger)enumId
                          type:(KLEnumType)type
                      iconName:(NSString *)iconName
                   descritpion:(NSString *)description;

@end
