//
//  PFobject+KL_Additions.h
//  Klike
//
//  Created by admin on 31/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (KL_Additions)

- (void)kl_setObject:(id)object forKey:(id<NSCopying>)key;

@end
