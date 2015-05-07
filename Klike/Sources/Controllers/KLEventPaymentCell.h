//
//  KLEventPaymentCell.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



@interface KLEventPaymentCell : KLEventPageCell {
    
    IBOutlet UIView *_viewBaseFree;
    
}

- (void)configureWithEvent:(KLEvent *)event;

@end
