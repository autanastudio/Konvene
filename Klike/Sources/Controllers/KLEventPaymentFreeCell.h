//
//  KLEventPaymentFreeCell.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



typedef NS_ENUM(NSUInteger, KLEventPaymentFreeCellState) {
    KLEventPaymentFreeCellStateGo,
    KLEventPaymentFreeCellStateGoing,
    KLEventPaymentFreeCellStateFree,
    KLEventPaymentFreeCellStatePassed,
};



@interface KLEventPaymentFreeCell : KLEventPageCell {
    
    IBOutlet UIView *_viewBaseFreeEvent;
    IBOutlet UIView *_viewBaseFree;
    IBOutlet UILabel *_labelFree;
    IBOutlet UILabel *_labelGo;
    IBOutlet UIImageView *_imageGo;
    
}

@property (nonatomic) KLEventPaymentFreeCellState state;

- (void)configureWithEvent:(KLEvent *)event;
- (void)setState:(KLEventPaymentFreeCellState)state;

@end
