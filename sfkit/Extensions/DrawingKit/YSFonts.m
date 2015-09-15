//
//  YSFonts.m
//  Drawing Kit
//
//  Created by Yarik Smirnov on 4/2/12.
//  Copyright (c) 2012 Drawing Kit All rights reserved.
//

#import "YSFonts.h"
#import <Foundation/Foundation.h>

static NSString * const _kYSFamilyNameMarkerFelt                = @"MarkerFelt%@";
static NSString * const _kYSFamilyNameTrebuchetMS               = @"Trebuchet%@";
static NSString * const _kYSFamilyNameArial                     = @"Arial%@MT";
static NSString * const _kYSFamilyNameMarion                    = @"Marion%@";
static NSString * const _kYSFamilyNameCochin                    = @"Cochin%@";
static NSString * const _kYSFamilyNameVerdana                   = @"Verdana%@";
static NSString * const _kYSFamilyNameCourier                   = @"Courier%@";
static NSString * const _kYSFamilyNameHelvetica                 = @"Helvetica%@";
static NSString * const _kYSFamilyNameTimesNewRoman             = @"TimeNewRomanPS%@MT";
static NSString * const _kYSFamilyNameFutura                    = @"Futura%@";
static NSString * const _kYSFamilyNameAmericaTypewriter         = @"AmericanTypewriter%@";
static NSString * const _kYSFamilyNameGeorgia                   = @"Georgia%@";
static NSString * const _kYSFamilyNameHelveticaNeue             = @"HelveticaNeue%@";
static NSString * const _kYSFamilyNameGillSans                  = @"GillSans%@";
static NSString * const _kYSFamilyNameCourierNew                = @"CourierNewPS%@MT";



static NSString * const _kYSFontStyleNameCondensedLight         = @"-CondensedLight";
static NSString * const _kYSFontStyleNameLigthOblique           = @"-LightOblique";
static NSString * const _kYSFontStyleNameLight                  = @"-Light";
static NSString * const _kYSFontStyleNameMedium                 = @"-Medium";
static NSString * const _kYSFontStyleNameMediumItalic           = @"-MediumItalic";
static NSString * const _kYSFontStyleNameRegular                = @"";  
static NSString * const _kYSFontStyleNameOblique                = @"-Oblique";
static NSString * const _kYSFontStyleNameUltraLight             = @"UltarItalic";
static NSString * const _kYSFontStyleNameItalic                 = @"-Italic";
static NSString * const _kYSFontStyleNameLightItalic            = @"-LightItalic";
static NSString * const _kYSFontStyleNameUltraLightItalic       = @"UltraLightItralic";
static NSString * const _kYSFontStyleNameBold                   = @"-Bold";
static NSString * const _kYSFontStyleNameBoldOblique            = @"-BoldOblique";
static NSString * const _kYSFontStyleNameBoldItalic             = @"-BoldItalic";
static NSString * const _kYSFontStyleNameCondensedBlack         = @"-CondensedBlack";
static NSString * const _kYSFontStyleNameCondensedExtraBold     = @"-CondensedExtraBold";
static NSString * const _kYSFontStyleNameCondensedBold          = @"-CondensedBold";


NSString * SFStringFromFontFamilyAndStyle(SFFontFamilyName family, SFFontStyle style)
{
    NSString *name = nil;
    NSString *styleStr = nil;
    
    YSFontFamilyNameId nameId = (YSFontFamilyNameId)family;
    YSFontStyleId styleId = (YSFontStyleId)style;
    
    switch (nameId) {
        case kYSFontFamilyNameMarkerFelt:
            name = _kYSFamilyNameMarkerFelt;
            break;
        case kYSFontFamilyNameTrebuchetMS:
            name = _kYSFamilyNameTrebuchetMS;
            break;
        case kYSFontFamilyNameArial:
            name = _kYSFamilyNameArial;
            break;
        case kYSFontFamilyNameMarion:
            name = _kYSFamilyNameMarion;
            break;
        case kYSFontFamilyNameCochin:
            name = _kYSFamilyNameCochin;
            break;
        case kYSFontFamilyNameVerdana:
            name = _kYSFamilyNameVerdana;
            break;
        case kYSFontFamilyNameCourier:
            name = _kYSFamilyNameCourier;
            break;
        case kYSFontFamilyNameHelvetica:
            name = _kYSFamilyNameHelvetica;
            break;
        case kYSFontFamilyNameTimesNewRoman:
            name = _kYSFamilyNameTimesNewRoman;
            break;
        case kYSFontFamilyNameFutura:
            name = _kYSFamilyNameFutura;
            break;
        case kYSFontFamilyNameAmericanTypewriter:
            name = _kYSFamilyNameAmericaTypewriter;
            break;
        case kYSFontFamilyNameGeorgia:
            name = _kYSFamilyNameGeorgia;
            break;
        case kYSFontFamilyNameHelveticaNeue:
            name = _kYSFamilyNameHelveticaNeue;
            break;
        case kYSFontFamilyNameGillSans:
            name = _kYSFamilyNameGillSans;
            break;
        case kYSFontFamilyNameCourierNew:
            name = _kYSFamilyNameCourierNew;
            break;
        default:
            return NULL;
    }
    
    switch (styleId) {
        case kYSFontStyleCondensedLight:
            styleStr = _kYSFontStyleNameCondensedLight;
            break;
        case kYSFontStyleLightOblique:
            styleStr = _kYSFontStyleNameLigthOblique;
            break;
        case kYSFontStyleLight:
            styleStr = _kYSFontStyleNameLight;
            break;
        case kYSFontStyleMedium:
            styleStr = _kYSFontStyleNameMedium;
            break;
        case kYSFontStyleMediumItalic:
            styleStr = _kYSFontStyleNameMediumItalic;
            break;
        case kYSFontStyleRegular:
            styleStr = _kYSFontStyleNameRegular;
            break;
        case kYSFontStyleOblique:
            styleStr = _kYSFontStyleNameOblique;
            break;
        case kYSFontStyleUltraLight:
            styleStr = _kYSFontStyleNameUltraLight;
            break;
        case kYSFontStyleUltraLightItalic:
            styleStr = _kYSFontStyleNameUltraLightItalic;
            break;
        case kYSFontStyleBold:
            styleStr = _kYSFontStyleNameBold;
            break;
        case kYSFontStyleBoldOblique:
            styleStr = _kYSFontStyleNameBoldOblique;
            break;
        case kYSFontStyleBoldItalic:
            styleStr = _kYSFontStyleNameBoldItalic;
            break;
        case kYSFontStyleCondensedBlack:
            styleStr = _kYSFontStyleNameCondensedBlack;
            break;
        case kYSFontStyleCondensedExtraBold:
            styleStr = _kYSFontStyleNameCondensedExtraBold;
            break;
        case kYSFontStyleCondensedBold:
            styleStr = _kYSFontStyleNameCondensedBold;
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:name, styleStr];
}


CTFontRef YSFontCreateFromWithNameAndStyleWithTransform(YSFontFamilyNameId nameId, YSFontStyleId styleId, CGFloat size, CGAffineTransform *transformationMatrix) {
    
    NSString *fontName = SFStringFromFontFamilyAndStyle(nameId, styleId);

    return CTFontCreateWithName((__bridge CFStringRef)fontName, size, transformationMatrix);
}

CTFontRef YSFontCreateFromWithNameAndStyle(YSFontFamilyNameId nameId, YSFontStyleId styleId, CGFloat size) {
    return YSFontCreateFromWithNameAndStyleWithTransform(nameId, styleId, size, NULL);
}


