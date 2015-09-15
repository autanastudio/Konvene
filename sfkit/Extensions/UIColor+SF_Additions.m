//
//  UIColor+SF_Additions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "UIColor+SF_Additions.h"
#import "SFFunctions.h"

@implementation UIColor (SF_Additions)

+ (UIColor *)colorFromHex:(NSUInteger)hex alpha:(CGFloat)alphaInPercentage {
    return SFColorGetWithHexAndAlpha(hex, alphaInPercentage);
}

+ (UIColor *)colorFromHex:(NSUInteger)hexademical {
    return [UIColor colorFromHex:hexademical alpha:100];
}

@end
