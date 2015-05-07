//
//  KLEventPaymentCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentCell.h"



@implementation KLEventPaymentCell 

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
    //if its free event
    if (true) {
        _viewBaseFree.hidden = NO;
        
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
}

@end
