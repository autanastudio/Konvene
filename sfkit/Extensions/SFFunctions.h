//
//  SFFunctions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//


#import "YSDrawingKit.h"
#import <UIKit/UIKit.h>

#define sf_key(name) NSStringFromSelector(@selector(name))

#define SFLocalizedString(key, comment) \
    [[[NSBundle mainBundle] localizedStringForKey:(key) value:nil table:nil] isEqualToString:(key)] ? \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"SFLocalizable"] : \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define SFLocalized(key) SFLocalizedString(key, nil)


UIColor * SFColorGetWithHex(NSUInteger hexColor);

UIColor * SFColorGetWithHexAndAlpha(NSUInteger hexColor, CGFloat alphaInPercents);

NSString * SFStringGetByFilteringPhone(NSString *phone);

NSString * SFMaskedPhoneNumber(NSString *phone);

NSString * SFStringByGroupingNumber(NSNumber *number);

UIImage * SFImageGetStretchable(NSString *name, CGFloat leftCap, CGFloat topCap);

/**
 Return formatted string from date
 @param date date
 @param format format
 */

NSString *SFStringFromDate(NSDate *date, NSString *format);

