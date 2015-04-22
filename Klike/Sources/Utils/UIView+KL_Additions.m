//
//  UIView+KL_Additions.m
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "UIView+KL_Additions.h"

@implementation UIView (KL_Additions)

- (void)kl_fromRectToCircle
{
    CGFloat halfSizeofImage = self.bounds.size.width/2.;
    [self.layer setCornerRadius:halfSizeofImage];
    [self.layer setMasksToBounds:YES];
}

@end
