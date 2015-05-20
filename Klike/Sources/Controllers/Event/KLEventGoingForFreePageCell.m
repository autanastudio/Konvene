//
//  KLEventGoingForFreePageCell.m
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGoingForFreePageCell.h"

@implementation KLEventGoingForFreePageCell

- (void)awakeFromNib
{
    _viewActive.backgroundColor = [UIColor colorFromHex:0x6466ca];
}

- (void)setActive:(BOOL)active
{
    _viewActive.hidden = active;
    _viewInactive.hidden = !active;
    
}

- (IBAction)onGo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goingForFreeCellDidPressGo)]) {
        [self.delegate performSelector:@selector(goingForFreeCellDidPressGo) withObject:nil];
    }

}

@end
