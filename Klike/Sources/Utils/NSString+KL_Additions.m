//
//  NSString+KL_Additions.m
//  Klike
//
//  Created by Alexey on 5/7/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "NSString+KL_Additions.h"

@implementation NSString (KL_Additions)

+ (NSString *)abbreviateNumber:(NSInteger)num
{
    NSString *abbrevNum;
    CGFloat number = (CGFloat)num;
    //Prevent numbers smaller than 1000 to return NULL
    if (num >= 1000) {
        NSArray *abbrev = @[@"k", @"M", @"B"];
        for (NSInteger i = abbrev.count - 1; i >= 0; i--) {
            // Convert array index to "1000", "1000000", etc
            NSInteger size = pow(10,(i+1)*3);
            if(size <= number) {
                // Removed the round and dec to make sure small numbers are included like: 1.1K instead of 1K
                number = number/size;
                NSString *numberString = [NSString floatToString:number];
                // Add the letter for the abbreviation
                abbrevNum = [NSString stringWithFormat:@"%@%@", numberString, [abbrev objectAtIndex:i]];
            }
        }
    } else {
        // Numbers like: 999 returns 999 instead of NULL
        abbrevNum = [NSString stringWithFormat:@"%d", (int)number];
    }
    return abbrevNum;
}

+ (NSString *)floatToString:(CGFloat)val
{
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    while (c == 48) { // 0
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
        //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
        if(c == 46) { // .
            ret = [ret substringToIndex:[ret length] - 1];
        }
    }
    return ret;
}

+ (NSString *)stringTimeSinceDate:(NSDate *)date
{
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    // print up to 24 hours as a relative offset
    if(timeSinceDate < 24.0 * 60.0 * 60.0){
        NSUInteger hoursSinceDate = (NSUInteger)(timeSinceDate / (60.0 * 60.0));
        switch(hoursSinceDate) {
            default:
                return [NSString stringWithFormat:@"%luh", (unsigned long)hoursSinceDate];
                break;
            case 0:{
                NSUInteger minutesSinceDate = (NSUInteger)(timeSinceDate / 60.0);
                return [NSString stringWithFormat:@"%lum", (unsigned long)minutesSinceDate];
            }
                break;
        }
    }else{
        NSUInteger daysSinceDate = (NSUInteger)(timeSinceDate / (24*60.0 * 60.0));
        return [NSString stringWithFormat:@"%lud", (unsigned long)daysSinceDate];
    }
}

+ (CGSize) text:(NSString *)text sizeWithFont:(UIFont *)font toSize:(CGSize) constrainedSize lineBreak:(NSLineBreakMode) lineBreakMode
{
    CGSize size;
    if ([text respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        size = [text sizeWithAttributes:@{
                                          NSFontAttributeName: font,
                                          NSParagraphStyleAttributeName: paragraphStyle,
                                          }];
    }
    else {
        size = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

@end
