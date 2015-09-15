//
//  YSGeometry.h
//  YSDrawingKit
//
//  Created by Yarik Smirnov on 10/4/11.
//  Copyright (c) 2011 Yarik Smirnov. All rights reserved.
//

#ifndef YarikSmirnov_YSGeometry_h
#define YarikSmirnov_YSGeometry_h

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


CGRect YSRectMakeFromSize(CGFloat width, CGFloat height);

CGRect YSRectMakeFromOrigin(CGFloat x, CGFloat y);

CGRect YSRectSetOriginX(CGRect rect, CGFloat xOrigin);

CGRect YSRectSetOriginY(CGRect rect, CGFloat yOrigin);

CGRect YSRectSetWidth(CGRect rect, CGFloat width);

CGRect YSRectSetHeight(CGRect rect, CGFloat heigth);

CGRect YSRectSetSize(CGRect rect, CGSize size);

CGRect YSRectStretchWidth(CGRect rect, CGFloat widthDiff);

CGRect SFRectInverseCoordinates(CGRect rect, CGRect parent);

CGPoint SFPointInverseCoordinates(CGPoint point, CGRect parent);

CGRect SFRectAppendRect(CGRect rect1, CGRect rect2);

CGRect SFRectInRectAspectFit(CGRect intialRect, CGRect parentRect);

CGAffineTransform YSAffineTransformIdentityScale(CGAffineTransform transform);

#endif
