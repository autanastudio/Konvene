//
//  NSString+KL_Additions.h
//  Klike
//
//  Created by Alexey on 5/7/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KL_Additions)

+ (NSString *)abbreviateNumber:(NSInteger)num;
+ (NSString *)floatToString:(CGFloat)val;

@end
