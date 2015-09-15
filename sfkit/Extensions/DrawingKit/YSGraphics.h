//
//  YSGraphics.h
//  YSDrawingKit
//
//  Created by Yarik Smirnov on 12/19/11.
//  Copyright (c) 2011 e-legion ltd. All rights reserved.
//



#ifndef YarikSmirnov_YSGraphics_h
#define YarikSmirnov_YSGraphics_h

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "YSFonts.h"


CGColorRef YSColorCreateWithRGBA(unsigned int hex);

CGColorRef YSColorCreateWithRGB(unsigned int hexadimical);

CGColorRef YSColorCreateWithRGBAndAlpha(unsigned int hex, CGFloat alphaInPercentage);

CGColorRef YSColorGetFromHexAndAlpha(unsigned int hex, CGFloat alpha) DEPRECATED_ATTRIBUTE;

CGColorRef  YSColorGetFromHex(unsigned int hex) DEPRECATED_ATTRIBUTE;

CGFontRef   YSCreateGraphicFontWithName(YSFontFamilyNameId fontName, YSFontStyleId, CGFloat size);

UIImage * YSImageGetStretchable(NSString *name, CGFloat topCap, CGFloat leftCap);


void YSPathAddRoundedStrechedRect(CGMutablePathRef path, CGFloat radius, CGRect rect);

void YSPathAddBottomRoundedRect(CGMutablePathRef path, CGFloat radius,  CGRect rect, CGMutablePathRef inverted, CGRect overall);


// Predefined Colors

CGColorRef YSColorCreateBlack(void);

CGColorRef YSColorCreateWhite(void);

CGColorRef YSColorCreateRed(void);

CGColorRef YSColorCreateGreen(void);

CGColorRef YSColorCreateBlue(void);

#endif