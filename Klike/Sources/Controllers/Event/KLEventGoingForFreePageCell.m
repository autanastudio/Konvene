//
//  KLEventGoingForFreePageCell.m
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGoingForFreePageCell.h"

@implementation KLEventGoingForFreePageCell


- (void)setActive:(BOOL)active
{
    _viewActive.hidden = active;
    _viewInactive.hidden = !active;
}

@end
