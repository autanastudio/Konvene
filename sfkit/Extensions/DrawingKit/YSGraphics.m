//
//  YSGraphics.m
//  YSDrawingKit
//
//  Created by Yarik Smirnov on 12/19/11.
//  Copyright (c) 2011 e-legion ltd. All rights reserved.
//

#import "YSGraphics.h"


CGColorRef  YSColorGetFromHex(unsigned int hex) { 
    return YSColorGetFromHexAndAlpha(hex, 100);
}

CGColorRef YSColorCreateWithRGBA(unsigned int hex) {
    CGFloat componets[] = {
            ((float)((hex & 0xFF000000) >> 24))/255.0,
            ((float)((hex & 0xFF0000) >> 16))/255.0,
            ((float)((hex & 0xFF00) >> 8))/255.0,
            ((float)(hex & 0xFF))/255.0
    };
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace, componets);
    
    CGColorSpaceRelease(colorSpace);
    
    return color;
}

CGColorRef YSColorCreateWithRGB(unsigned int hexadimical) {
    unsigned int hexWithRGBA = (hexadimical << 8) | 0xFF;
    return YSColorCreateWithRGBA(hexWithRGBA);
}

CGColorRef YSColorCreateWithRGBAndAlpha(unsigned int hex, CGFloat alphaInPercentage) {
    unsigned int hexColorWithAlpha = (unsigned int)((hex << 8) | (unsigned int)rintf((alphaInPercentage / 100) * 255.0));
    return YSColorCreateWithRGBA(hexColorWithAlpha);
}

CGColorRef YSColorGetFromHexAndAlpha(unsigned int hex, CGFloat alpha) {
    unsigned int hexColorWithAlpha = (unsigned int)((hex << 8) | (unsigned int)rintf((alpha / 100) * 255.0));
    CGColorRef color = YSColorCreateWithRGBA(hexColorWithAlpha);
    UIColor *colorui = [UIColor colorWithCGColor:color];
    CGColorRelease(color);
    return colorui.CGColor;
}


void YSPathAddRoundedStrechedRect(CGMutablePathRef path, CGFloat radius, CGRect rect) {
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, TRUE);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGPathAddArc(path, NULL,rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, TRUE);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGPathAddArc(path, NULL,rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, TRUE);
    CGPathAddLineToPoint(path, NULL,rect.origin.x + radius, rect.origin.y);
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, TRUE);
}


void YSPathAddBottomRoundedRect(CGMutablePathRef path, CGFloat radius, CGRect rect, CGMutablePathRef inverted, CGRect overall) {
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect) + radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect) + radius);
    CGPathAddArc(path, NULL,CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 0.0f, -M_PI / 2, TRUE);
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGPathAddArc(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, -M_PI / 2, M_PI, TRUE);
    
    if (inverted) {
        CGPathAddRect(inverted, NULL, CGRectMake(CGRectGetMinX(overall), CGRectGetMinY(overall), CGRectGetMinX(rect) - CGRectGetMinX(overall), CGRectGetHeight(overall)));
        CGPathAddRect(inverted, NULL, CGRectMake(CGRectGetMinX(overall), CGRectGetMinY(overall), CGRectGetWidth(overall), CGRectGetMinY(rect) - CGRectGetMinY(overall)));
        CGPathAddRect(inverted, NULL, CGRectMake(CGRectGetMinX(overall),CGRectGetMaxY(rect), CGRectGetWidth(overall), CGRectGetMaxY(overall) - CGRectGetMaxY(rect)));
        CGPathAddRect(inverted, NULL, CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(overall), CGRectGetMaxX(overall) - CGRectGetMaxX(rect), CGRectGetHeight(overall)));
                                                     
    }
}

UIImage * YSImageGetStretchable(NSString *name, CGFloat topCap, CGFloat leftCap)    {
    return [[UIImage imageNamed:name] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}


CGColorRef YSColorCreateBlack(void) {
    return YSColorCreateWithRGBA(0x000000FF);
}

CGColorRef YSColorCreateWhite(void) {
    return YSColorCreateWithRGBA(0xFFFFFFFF);
}

CGColorRef YSColorCreateRed(void) {
    return YSColorCreateWithRGBA(0xFF0000FF);
}

CGColorRef YSColorCreateGreen(void) {
    return YSColorCreateWithRGBA(0x00FF00FF);
}

CGColorRef YSColorCreateBlue(void) {
    return YSColorCreateWithRGBA(0x0000FFFF);
}

