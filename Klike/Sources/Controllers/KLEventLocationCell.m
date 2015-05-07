//
//  KLEventLocationCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventLocationCell.h"



@implementation KLEventLocationCell

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
    
}

- (IBAction)onLocation:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(locationCellDidPress)]) {
        [self.delegate performSelector:@selector(locationCellDidPress) withObject:nil];
    }
}

@end
