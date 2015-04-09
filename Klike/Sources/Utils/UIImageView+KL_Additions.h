//
//  UIImageView+KL_Additions.h
//  Klike
//
//  Created by admin on 26/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (KL_Additions)

- (void)kl_fromRectToCircle;
+ (NSArray *)imagesForAnimationWithnamePattern:(NSString *)namePattern
                                         count:(NSNumber *)count;

@end
