//
//  KLEventPaymentFinishedPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentFinishedPageCell.h"

@interface UIImage (UIImageFunctions)

@end

@implementation UIImage (UIImageFunctions)

- (UIImage *) scaleToSize: (CGSize)size
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

@end



@implementation KLEventPaymentFinishedPageCell

- (void)awakeFromNib
{
    _color = [UIColor colorFromHex:0x0494b3];
    
    CGSize sz = _imageEvent.frame.size;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, sz.width, sz.height);
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"p_halftone_pic_mask"] CGImage];
    _imageEvent.layer.mask = maskLayer;
    
    [self setThrowInInfo];
}

- (void)setType:(KLEventPaymentFinishedPageCellType)type
{
    if (type == KLEventPaymentFinishedPageCellTypeBuy)
    {
        _color = [UIColor colorFromHex:0x5d93e3];
        _viewBackground.backgroundColor = _color;
        _imageEvent.backgroundColor = _color;
        _imageCorner.image = [UIImage imageNamed:@"p_ticket_m"];
        _imageCornerL.image = [UIImage imageNamed:@"p_ticket_l"];
    }
    else
    {
        _color = [UIColor colorFromHex:0x0494b3];
        _viewBackground.backgroundColor = _color;
        _imageEvent.backgroundColor = _color;
        _imageCorner.image = [UIImage imageNamed:@"p_ticket_throw_in_m"];
        _imageCornerL.image = [UIImage imageNamed:@"p_ticket_throw_in_l"];
        
    }
    _labelThrowedIn.hidden = type == KLEventPaymentFinishedPageCellTypeBuy;
    _labelTickets.hidden = type != KLEventPaymentFinishedPageCellTypeBuy;
    _labelTicketsBottom.hidden = type != KLEventPaymentFinishedPageCellTypeBuy;
    [self setEventImage:[UIImage imageNamed:@"TestPhotoUser_0"]];
}

- (void)setEventImage:(UIImage*)image
{
    image = [image scaleToSize:CGSizeMake(image.size.width * 2, image.size.height * 2)];
    //  Convert UIColor to CIColor
    CGColorRef colorRef = [UIColor blackColor].CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    CIColor *coreColor = [CIColor colorWithString:colorString];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIDotScreen"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@0.3 forKey:kCIInputSharpnessKey];
    [filter setValue:@4.0 forKey:@"inputWidth"];
    CIImage *result = filter.outputImage;
    
    filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:result forKey:kCIInputImageKey];
    result = filter.outputImage;

    filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    [filter setValue:result forKey:kCIInputImageKey];
    result = filter.outputImage;
    
    filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:result forKey:kCIInputImageKey];
    result = filter.outputImage;
    
    filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:result forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:@"inputIntensity"];
    [filter setValue:coreColor forKey:@"inputColor"];
    result = [filter valueForKey:kCIOutputImageKey];
    
    
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    _imageEvent.image = filteredImage;
}

- (void)setThrowInInfo
{
    [self setType:(KLEventPaymentFinishedPageCellTypeThrow)];
}

- (void)setBuyTicketsInfo
{
    [self setType:(KLEventPaymentFinishedPageCellTypeBuy)];
}

@end
