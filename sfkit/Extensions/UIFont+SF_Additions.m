//
//  UIFont+SF_Additions.m
//  Livid
//
//  Created by Yarik Smirnov on 02/12/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import "UIFont+SF_Additions.h"

static NSString * const _kSFFamilyNameMarkerFelt                = @"MarkerFelt%@";
static NSString * const _kSFFamilyNameTrebuchetMS               = @"Trebuchet%@";
static NSString * const _kSFFamilyNameArial                     = @"Arial%@MT";
static NSString * const _kSFFamilyNameMarion                    = @"Marion%@";
static NSString * const _kSFFamilyNameCochin                    = @"Cochin%@";
static NSString * const _kSFFamilyNameVerdana                   = @"Verdana%@";
static NSString * const _kSFFamilyNameCourier                   = @"Courier%@";
static NSString * const _kSFFamilyNameHelvetica                 = @"Helvetica%@";
static NSString * const _kSFFamilyNameTimesNewRoman             = @"TimeNewRomanPS%@MT";
static NSString * const _kSFFamilyNameFutura                    = @"Futura%@";
static NSString * const _kSFFamilyNameAmericaTypewriter         = @"AmericanTypewriter%@";
static NSString * const _kSFFamilyNameGeorgia                   = @"Georgia%@";
static NSString * const _kSFFamilyNameHelveticaNeue             = @"HelveticaNeue%@";
static NSString * const _kSFFamilyNameGillSans                  = @"GillSans%@";
static NSString * const _kSFFamilyNameCourierNew                = @"CourierNewPS%@MT";



static NSString * const _kSFFontStyleNameCondensedLight         = @"-CondensedLight";
static NSString * const _kSFFontStyleNameLigthOblique           = @"-LightOblique";
static NSString * const _kSFFontStyleNameLight                  = @"-Light";
static NSString * const _kSFFontStyleNameMedium                 = @"-Medium";
static NSString * const _kSFFontStyleNameMediumItalic           = @"-MediumItalic";
static NSString * const _kSFFontStyleNameRegular                = @"";
static NSString * const _kSFFontStyleNameOblique                = @"-Oblique";
static NSString * const _kSFFontStyleNameUltraLight             = @"UltarItalic";
static NSString * const _kSFFontStyleNameItalic                 = @"-Italic";
static NSString * const _kSFFontStyleNameLightItalic            = @"-LightItalic";
static NSString * const _kSFFontStyleNameUltraLightItalic       = @"UltraLightItralic";
static NSString * const _kSFFontStyleNameBold                   = @"-Bold";
static NSString * const _kSFFontStyleNameBoldOblique            = @"-BoldOblique";
static NSString * const _kSFFontStyleNameBoldItalic             = @"-BoldItalic";
static NSString * const _kSFFontStyleNameCondensedBlack         = @"-CondensedBlack";
static NSString * const _kSFFontStyleNameCondensedExtraBold     = @"-CondensedExtraBold";
static NSString * const _kSFFontStyleNameCondensedBold          = @"-CondensedBold";

@implementation UIFont (SF_Additions)

+ (NSString *)_fontNameWithFamily:(SFFontFamilyName)familyID style:(SFFontStyle)styleID
{
    NSString *nameString, *styleString;
    switch (familyID) {
        case SFFontFamilyNameMarkerFelt:
            nameString = _kSFFamilyNameMarkerFelt;
            break;
        case SFFontFamilyNameTrebuchetMS:
            nameString = _kSFFamilyNameTrebuchetMS;
            break;
        case SFFontFamilyNameArial:
            nameString = _kSFFamilyNameArial;
            break;
        case SFFontFamilyNameMarion:
            nameString = _kSFFamilyNameMarion;
            break;
        case SFFontFamilyNameCochin:
            nameString = _kSFFamilyNameCochin;
            break;
        case SFFontFamilyNameVerdana:
            nameString = _kSFFamilyNameVerdana;
            break;
        case SFFontFamilyNameCourier:
            nameString = _kSFFamilyNameCourier;
            break;
        case SFFontFamilyNameHelvetica:
            nameString = _kSFFamilyNameHelvetica;
            break;
        case SFFontFamilyNameTimesNewRoman:
            nameString = _kSFFamilyNameTimesNewRoman;
            break;
        case SFFontFamilyNameFutura:
            nameString = _kSFFamilyNameFutura;
            break;
        case SFFontFamilyNameAmericanTypewriter:
            nameString = _kSFFamilyNameAmericaTypewriter;
            break;
        case SFFontFamilyNameGeorgia:
            nameString = _kSFFamilyNameGeorgia;
            break;
        case SFFontFamilyNameHelveticaNeue:
            nameString = _kSFFamilyNameHelveticaNeue;
            break;
        case SFFontFamilyNameGillSans:
            nameString = _kSFFamilyNameGillSans;
            break;
        case SFFontFamilyNameCourierNew:
            nameString = _kSFFamilyNameCourierNew;
            break;
        default:
            return NULL;
    }
    
    switch (styleID) {
        case SFFontStyleCondensedLight:
            styleString = _kSFFontStyleNameCondensedLight;
            break;
        case SFFontStyleLight:
            styleString = _kSFFontStyleNameLight;
            break;
        case SFFontStyleMedium:
            styleString = _kSFFontStyleNameMedium;
            break;
        case SFFontStyleRegular:
            styleString = _kSFFontStyleNameRegular;
            break;
        case SFFontStyleUltraLight:
            styleString = _kSFFontStyleNameUltraLight;
            break;
        case SFFontStyleUltraLightItalic:
            styleString = _kSFFontStyleNameUltraLightItalic;
            break;
        case SFFontStyleBold:
            styleString = _kSFFontStyleNameBold;
            break;
        case SFFontStyleBoldItalic:
            styleString = _kSFFontStyleNameBoldItalic;
            break;
        case SFFontStyleCondensedBlack:
            styleString = _kSFFontStyleNameCondensedBlack;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:nameString, styleString];
}

+ (UIFont *)fontWithFamily:(SFFontFamilyName)family style:(SFFontStyle)style size:(CGFloat)size
{
    NSString *fontName = [self _fontNameWithFamily:family style:style];
    return [UIFont fontWithName:fontName size:size];
}

+ (UIFont *)helveticaNeue:(SFFontStyle)style size:(CGFloat)size
{
    return [self fontWithFamily:SFFontFamilyNameHelveticaNeue style:style size:size];
}

@end
