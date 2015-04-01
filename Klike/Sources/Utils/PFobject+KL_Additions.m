//
//  PFobject+KL_Additions.m
//  Klike
//
//  Created by admin on 31/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "PFobject+KL_Additions.h"

@implementation PFObject (KL_Additions)

- (void)kl_setObject:(id)object forKey:(id)key
{
    if (object && key) {
        if ([object isKindOfClass:[NSString class]]) {
            if (![(NSString *)object notEmpty]) {
                return;
            }
        }
        self[key] = object;
    }
}

@end
