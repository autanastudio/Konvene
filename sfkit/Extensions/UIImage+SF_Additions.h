//
//  UIImage+SF_Additions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SF_Additions)

- (BOOL)hasTransparentPixels;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end