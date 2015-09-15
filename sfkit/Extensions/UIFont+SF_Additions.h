//
//  UIFont+SF_Additions.h
//  Livid
//
//  Created by Yarik Smirnov on 02/12/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SFFontFamilyName) {
    SFFontFamilyNameMarkerFelt,
    SFFontFamilyNameTrebuchetMS,
    SFFontFamilyNameArial,
    SFFontFamilyNameMarion,
    SFFontFamilyNameCochin,
    SFFontFamilyNameVerdana,
    SFFontFamilyNameCourier,
    SFFontFamilyNameHelvetica,
    SFFontFamilyNameTimesNewRoman,
    SFFontFamilyNameFutura,
    SFFontFamilyNameAmericanTypewriter,
    SFFontFamilyNameGeorgia,
    SFFontFamilyNameHelveticaNeue,
    SFFontFamilyNameGillSans,
    SFFontFamilyNameCourierNew,
};

enum {
    SFFontStyleCondensedLight,
    SFFontStyleLight,
    SFFontStyleMedium,
    SFFontStyleRegular,
    SFFontStyleUltraLight,
    SFFontStyleItalic,
    SFFontStyleLightItalic,
    SFFontStyleUltraLightItalic,
    SFFontStyleBold,
    SFFontStyleBoldItalic,
    SFFontStyleCondensedBlack,
    SFFontStyleCondensedBold,
};
typedef unsigned int SFFontStyle;

@interface UIFont (SF_Additions)

+ (UIFont *)fontWithFamily:(SFFontFamilyName)family style:(SFFontStyle)style size:(CGFloat)size;

+ (UIFont *)helveticaNeue:(SFFontStyle)style size:(CGFloat)size;

@end
