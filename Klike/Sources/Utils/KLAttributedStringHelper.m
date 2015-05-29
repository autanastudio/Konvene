//
//  KLAttributedStringHelper.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAttributedStringHelper.h"

@implementation KLAttributedStringPart

- (instancetype)initWithString:(NSString *)string
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    self = [super init];
    if (self) {
        self.stringPart = string;
        self.color = color;
        self.font = font;
    }
    return self;
}

+ (KLAttributedStringPart *)partWithString:(NSString *)string
                                     color:(UIColor *)color
                                      font:(UIFont *)font
{
    return [[KLAttributedStringPart alloc] initWithString:string
                                                    color:color
                                                     font:font];
}

@end

@implementation KLAttributedStringHelper

+ (NSMutableAttributedString *)stringWithParts:(NSArray *)parts
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    for (KLAttributedStringPart *part in parts) {
        NSDictionary * attributes = @{ NSForegroundColorAttributeName : part.color,
                                       NSFontAttributeName : part.font};
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:part.stringPart
                                                                         attributes:attributes];
        [string appendAttributedString:subString];
    }
    return string;
}

+ (NSMutableAttributedString *)coloredStringWithDictionary:(NSDictionary *)colorMappingDict
                                                      font:(UIFont *)font
{
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString * word in colorMappingDict) {
        UIColor * color = [colorMappingDict objectForKey:word];
        KLAttributedStringPart *part = [KLAttributedStringPart partWithString:word
                                                                        color:color
                                                                         font:font];
        [parts addObject:part];
    }
    return [KLAttributedStringHelper stringWithParts:parts];
}

+ (NSMutableAttributedString *)stringWithFont:(UIFont *)font
                                        color:(UIColor *)color
                            minimumLineHeight:(NSNumber *)minimumLineHeight
                             charecterSpacing:(NSNumber *)charSpacing
                                       string:(NSString *)string
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes sf_setObject:color forKey:NSForegroundColorAttributeName];
    [attributes sf_setObject:font forKey:NSFontAttributeName];
    [attributes sf_setObject:charSpacing forKey:NSKernAttributeName];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = [minimumLineHeight floatValue];
    style.alignment = NSTextAlignmentCenter;
    [attributes sf_setObject:style forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return attributedString;
}

@end
