//
//  UIImageView+KL_Additions.m
//  Klike
//
//  Created by admin on 26/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "UIImageView+KL_Additions.h"

@implementation UIImageView (KL_Additions)

+ (NSArray *)imagesForAnimationWithnamePattern:(NSString *)namePattern
                                         count:(NSNumber *)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[count integerValue]; i++) {
        NSString *imageName = [NSString stringWithFormat:namePattern, i];
        [array addObject:[UIImage imageNamed:imageName]];
    }
    return array;
}

@end
