//
//  SFFunctions.c
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "SFFunctions.h"

UIFont * SFFontGetFromFamilyName(SFFontFamilyName familyName, SFFontStyle style, CGFloat pointSize) {
    CTFontRef ctFont = YSFontCreateFromWithNameAndStyle(familyName, style, pointSize);
    CFStringRef name = CTFontCopyPostScriptName(ctFont);
    
    UIFont * font = [UIFont fontWithName:(__bridge NSString *)name size:pointSize];
    if (!font) {
        SFFontStyle replaceStyle = SFFontStyleRegular;
        switch (style) {
            case SFFontStyleMedium:
                replaceStyle = SFFontStyleRegular;
                break;
            case SFFontStyleLight:
                replaceStyle = SFFontStyleRegular;
                break;
            case SFFontStyleCondensedBold:
                replaceStyle = SFFontStyleBold;
                break;
            default:
                break;
        }
        font = SFFontGetFromFamilyName(familyName, replaceStyle, pointSize);
    }
    
    CFRelease(ctFont);
    CFRelease(name);
    
    return font;
}

UIFont * SFFontGetHelveticaNeue(CGFloat pointSize, SFFontStyle fontStyle) {
    return SFFontGetFromFamilyName(SFFontFamilyNameHelveticaNeue, fontStyle, pointSize);
}

UIColor * SFColorGetWithHex(NSUInteger hexColor) {
    return SFColorGetWithHexAndAlpha(hexColor, 100);
}

UIColor * SFColorGetWithHexAndAlpha(NSUInteger hexColor, CGFloat alphaInPercents) {
    unsigned int hexColorWithAlpha = (unsigned int)((hexColor << 8) | (unsigned int)rintf((alphaInPercents / 100) * 255.0));
    CGColorRef graphicColor = YSColorCreateWithRGBA(hexColorWithAlpha);
    
    UIColor *color = [UIColor colorWithCGColor:graphicColor];
    
    CGColorRelease(graphicColor);
    
    return color;
}
NSString * SFStringGetByFilteringPhone(NSString *phone) {
    return [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"+0123456789-()"] invertedSet]] componentsJoinedByString:@""];
}


NSString * SFMaskedPhoneNumber(NSString *phone) {
    NSMutableString *result = [NSMutableString string];
    BOOL hasPlus = NO;
    if ([phone rangeOfString:@"+"].length > 0) {
        hasPlus = YES;
        phone = [phone substringFromIndex:1];
    }
    for (int i = 0; i < [phone length]; i ++) {
        if (i == 1 && (hasPlus || [phone length] > 7)) {
            [result appendString:@" ("];
        }
        if ((i == 3 || i == 5)&& !hasPlus && [phone length] < 8) {
            [result appendString:@"-"];
        }
        if (i == 4 && (hasPlus || [phone length] > 7)) {
            [result appendString:@") "];
        }
        if ((i == 7 || i == 9) && (hasPlus || [phone length] > 7)) {
            [result appendString:@"-"];
        }
        [result appendString:[phone substringWithRange:NSMakeRange(i, 1)]];
    }
    if ([phone length] < 5 && [phone length] > 1 && hasPlus) {
        for (int j = 0; j < 4 - [phone length]; j++) {
            [result appendString:@" "];
        }
        [result appendString:@")"];
    }
    if (hasPlus) {
        [result insertString:@"+" atIndex:0];
    }
    return result;
}

NSString * SFStringByGroupingNumber(NSNumber *number) {
    static NSNumberFormatter *nf = nil;
    if (!nf) {
        nf = [[NSNumberFormatter alloc] init];
        [nf setGroupingSize:3];
        [nf setGroupingSeparator:@" "];
        [nf setUsesGroupingSeparator:YES];
        [nf setMaximumFractionDigits:2];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        [nf setDecimalSeparator:@","];
    }
    
    return [nf stringFromNumber:number];
}

NSString *SFStringFromDate(NSDate *date, NSString *format) {
    date = [date dateByAddingTimeInterval:-4*60*60];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GTM"];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

UIImage * SFImageGetStretchable(NSString *name, CGFloat leftCap, CGFloat topCap) {
    return [[UIImage imageNamed:name] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

