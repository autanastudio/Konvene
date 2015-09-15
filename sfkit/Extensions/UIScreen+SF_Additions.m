

//
//  UIScreen+SF_Additions.m
//  Livid
//
//  Created by Yarik Smirnov on 3/23/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "UIScreen+SF_Additions.h"

@implementation UIScreen (SF_Additions)

+ (BOOL)is3_5Inch
{
    return [[UIScreen mainScreen] bounds].size.height == 480;
}

@end
