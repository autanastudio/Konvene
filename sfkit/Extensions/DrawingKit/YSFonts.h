//
//  YSFonts.h
//  Drawing Kit
//
//  Created by Yarik Smirnov on 4/2/12.
//  Copyright (c) 2012 YArik Smirnov All rights reserved.
//

#ifndef YarikSmirnov_YSFonts_h
#define YarikSmirnov_YSFonts_h

#import <CoreText/CoreText.h>

enum {
    kYSFontFamilyNameMarkerFelt,
    kYSFontFamilyNameTrebuchetMS,
    kYSFontFamilyNameArial,
    kYSFontFamilyNameMarion,
    kYSFontFamilyNameCochin,
    kYSFontFamilyNameVerdana,
    kYSFontFamilyNameCourier,
    kYSFontFamilyNameHelvetica,
    kYSFontFamilyNameTimesNewRoman,
    kYSFontFamilyNameFutura,
    kYSFontFamilyNameAmericanTypewriter,
    kYSFontFamilyNameGeorgia,
    kYSFontFamilyNameHelveticaNeue,
    kYSFontFamilyNameGillSans,
    kYSFontFamilyNameCourierNew,
};
typedef unsigned int YSFontFamilyNameId;


enum {
    kYSFontStyleCondensedLight,
    kYSFontStyleLightOblique,
    kYSFontStyleLight,
    kYSFontStyleMedium,
    kYSFontStyleMediumItalic,
    kYSFontStyleRegular,
    kYSFontStyleOblique,
    kYSFontStyleUltraLight,
    kYSFontStyleItalic,
    kYSFontStyleLightItalic,
    kYSFontStyleUltraLightItalic,
    kYSFontStyleBold,
    kYSFontStyleBoldOblique,
    kYSFontStyleBoldItalic,
    kYSFontStyleCondensedBlack,
    kYSFontStyleCondensedExtraBold,
    kYSFontStyleCondensedBold,
};
typedef unsigned int YSFontStyleId;

CTFontRef YSFontCreateFromWithNameAndStyleWithTransform(YSFontFamilyNameId nameId, YSFontStyleId styleId, CGFloat size, CGAffineTransform *transformationMatrix);


CTFontRef YSFontCreateFromWithNameAndStyle(YSFontFamilyNameId nameId, YSFontStyleId styleId, CGFloat size);

#endif