//
//  YSGeometry.c
//  YSDrawingKit
//
//  Created by Yarik Smirnov on 10/4/11.
//  Copyright (c) 2011 Yarik Smirnov. All rights reserved.
//

#import "YSGeometry.h"

CGRect YSRectMakeFromSize(CGFloat width, CGFloat height) {
    return CGRectMake(0, 0, width, height);
}

CGRect YSRectMakeFromOrigin(CGFloat x, CGFloat y) {
    return CGRectMake(x, y, 0, 0);
}

CGRect YSRectSetOriginX(CGRect rect, CGFloat xOrigin) {
    return CGRectMake(xOrigin, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect YSRectSetOriginY(CGRect rect, CGFloat yOrigin) {
    return CGRectMake(rect.origin.x, yOrigin, rect.size.width, rect.size.height);
}

CGRect YSRectSetWidth(CGRect rect, CGFloat width) {
    return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect YSRectSetHeight(CGRect rect, CGFloat height) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect YSRectSetSize(CGRect rect, CGSize size) {
    return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect YSRectStretchWidth(CGRect rect, CGFloat widthDiff) {
    return CGRectMake(CGRectGetMinX(rect) - widthDiff, CGRectGetMinY(rect), CGRectGetWidth(rect) + 2 * widthDiff, CGRectGetHeight(rect));
}

CGRect SFRectInverseCoordinates(CGRect rect, CGRect parent) {
    return CGRectMake(CGRectGetMinX(rect), CGRectGetHeight(parent) - CGRectGetMaxY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}

CGPoint SFPointInverseCoordinates(CGPoint point, CGRect parent) {
    return CGPointMake(point.x, CGRectGetHeight(parent) - point.y);
}

CGRect SFRectInRectAspectFit(CGRect intialRect, CGRect parentRect) {
    
    CGFloat parentRatio = parentRect.size.width / parentRect.size.height;
    CGFloat rectRatio = intialRect.size.width / intialRect.size.height;
    
    CGSize retSize;
    
    if (parentRatio > rectRatio) {
        retSize = CGSizeMake(CGRectGetWidth(intialRect) * (CGRectGetHeight(parentRect) / CGRectGetHeight(intialRect)), CGRectGetHeight(intialRect) * (CGRectGetHeight(parentRect) / CGRectGetHeight(intialRect)));
    } else {
        retSize = CGSizeMake(CGRectGetWidth(intialRect) * CGRectGetWidth(parentRect), CGRectGetHeight(intialRect));
    }
    
    return YSRectSetSize(intialRect, retSize);
}

CGAffineTransform YSAffineTransformIdentityScale(CGAffineTransform transform) {
    return CGAffineTransformConcat(transform, CGAffineTransformMakeScale(1.0, 1.0));
}

