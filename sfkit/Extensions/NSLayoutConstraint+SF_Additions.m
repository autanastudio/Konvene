//
//  NSLayoutConstraint+SF_Additions.m
//  Livid
//
//  Created by Yarik Smirnov on 3/25/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "NSLayoutConstraint+SF_Additions.h"

@implementation NSLayoutConstraint (SF_Additions)

- (void)setFloatConstant:(CGFloat)floatConstant
{
    self.constant = floatConstant;
}

- (CGFloat)floatConstant
{
    return self.constant;
}

@end
