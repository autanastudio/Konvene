//
//  KLEventPaymentFreeCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentFreeCell.h"
#import "KLActivityIndicator.h"



@implementation KLEventPaymentFreeCell 

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    

    _viewBaseFree.hidden = NO;
    _viewBaseFreeEvent.hidden = YES;
    
    _labelFree.text = SFLocalized(@"eventCellPaymentFree");
    if (true) {
        _imageGo.image = [UIImage imageNamed:@"going_active"];
        _labelGo.text = SFLocalized(@"eventCellPaymentGo");
    }
    else {
        _imageGo.image = [UIImage imageNamed:@"going_inactive"];
        _labelGo.text = SFLocalized(@"eventCellPaymentGoing");
    }
    
    
}

- (IBAction)onFree:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(paypentCellDidPressFree)]) {
        [self.delegate performSelector:@selector(paypentCellDidPressFree) withObject:nil];
    }
}

- (void)setState:(KLEventPaymentFreeCellState)state
{
    _state = state;
    if (state == KLEventPaymentFreeCellStateGo) {
        _viewBaseFree.hidden = NO;
        _viewBaseFreeEvent.hidden = YES;
        _imageGo.image = [UIImage imageNamed:@"going_active"];
        _labelGo.text = SFLocalized(@"eventCellPaymentGo");
        
        _constraintImageIconX.constant = 9;
        _constraintLabelGoingX.constant = -45;
    }
    else if (state == KLEventPaymentFreeCellStateGoing) {
        _viewBaseFree.hidden = NO;
        _viewBaseFreeEvent.hidden = YES;
        _imageGo.image = [UIImage imageNamed:@"going_inactive"];
        _labelGo.text = SFLocalized(@"eventCellPaymentGoing");
    }
    else {
        _viewBaseFree.hidden = YES;
        _viewBaseFreeEvent.hidden = NO;
        
    }
}
- (void)setLoading:(BOOL)loading
{
    if (loading) {
        
        _activity = [KLActivityIndicator whiteIndicator];
        [_viewMin addSubview:_activity];
        [_activity autoCenterInSuperview];
        [_activity setAnimating:YES];
        
        _imageGo.alpha = 0;
        _labelGo.alpha = 0;
    }
    else
    {
        [_activity removeFromSuperview];
        _activity = nil;
        _imageGo.alpha = 1;
        _labelGo.alpha = 1;
    }
}

@end
