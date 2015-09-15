//
//  UIImage+SF_Additions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "UIImage+SF_Additions.h"

@implementation UIImage (SF_Additions)

- (BOOL)hasTransparentPixels {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char * bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    float           width = self.size.width * self.scale;
    float           height = self.size.height * self.scale;
    
    bitmapBytesPerRow   = (width * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * height);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();// 2
    
    bitmapData = (unsigned char *)malloc( bitmapByteCount );// 3
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NO;
    }
    
    context = CGBitmapContextCreate (bitmapData,// 4
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), self.CGImage);
    
    BOOL hasTransparetPixel = NO;
    
    for (int i = 0; i < bitmapByteCount / 4; i += 4) {
        //        CGFloat red = (CGFloat)bitmapData[i] / 255.0;
        //        CGFloat green = (CGFloat)bitmapData[i+1] / 255.0;
        //        CGFloat blue = (CGFloat)bitmapData[i+2] / 255.0;
        CGFloat alpha = (CGFloat)bitmapData[i+3] / 255.0;
        //        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        //        CGFloat alphaValue = CGColorGetAlpha(color.CGColor);
        if (alpha < 1 && alpha > 0) {
            hasTransparetPixel = YES;
            break;
        }
    }
    
    CGColorSpaceRelease( colorSpace );// 6
    CGContextRelease(context);
    free(bitmapData);
    
    return hasTransparetPixel;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 48.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
