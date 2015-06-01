//
//  KLEventGoingForFreePageCell.m
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGoingForFreePageCell.h"
#import "KLActivityIndicator.h"



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

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    [self setActive:![self.event.attendees containsObject:[KLAccountManager sharedManager].currentUser.userObject.objectId]];
}

- (void)setLoading:(BOOL)loading
{
    if (loading) {
        
        _activity = [KLActivityIndicator colorIndicator];
        [_viewMain addSubview:_activity];
        [_activity autoCenterInSuperview];
        [_activity setAnimating:YES];
        _viewInactive.alpha = 0;
        _viewActive.alpha = 0;
    }
    else
    {
        [_activity removeFromSuperview];
        _activity = nil;
        _viewInactive.alpha = 1;
        _viewActive.alpha = 1;
    }
}

@end
