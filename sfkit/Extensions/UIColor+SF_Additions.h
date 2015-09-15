//
//  UIColor+SF_Additions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SF_Additions)

+ (UIColor *)colorFromHex:(NSUInteger)hex alpha:(CGFloat)alphaInPercentage;

+ (UIColor *)colorFromHex:(NSUInteger)hexademical;

@end
