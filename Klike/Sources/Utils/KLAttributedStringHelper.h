//
//  KLAttributedStringHelper.h
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAttributedStringPart : NSObject
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *stringPart;

- (instancetype)initWithString:(NSString *)string
                         color:(UIColor *)color
                          font:(UIFont *)font;

+ (KLAttributedStringPart *)partWithString:(NSString *)string
                                     color:(UIColor *)color
                                      font:(UIFont *)font;

@end

@interface KLAttributedStringHelper : NSObject

+ (NSMutableAttributedString *)stringWithParts:(NSArray *)parts;
+ (NSMutableAttributedString *)coloredStringWithDictionary:(NSDictionary *)colorMappingDict
                                                      font:(UIFont *)font;

@end
