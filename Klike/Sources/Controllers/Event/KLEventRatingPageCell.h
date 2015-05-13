//
//  KLEventRatingPageCell.h
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



@interface KLEventRatingPageCell : KLEventPageCell {
    
    IBOutlet UILabel *_labelRating;
    IBOutlet NSLayoutConstraint *_constraintViewActiveWidth;
    IBOutlet NSLayoutConstraint *_constraintViewActiveTotalWidth;
    
    IBOutlet UIView *_viewActive;
}

- (void)setRating:(float)rating animated:(BOOL)animated;

@end
