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
    
    IBOutlet UIView *_viewInactive;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveExternalX;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveExternalWidth;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveInternalX;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveInternalWidth;
    IBOutlet UIView *_viewInactiveColored;
    IBOutlet UIView *_viewInactiveGray;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveInternalGrayX;
    IBOutlet NSLayoutConstraint *_constraintViewInactiveInternalGrayWidth;
    IBOutlet UIView *_viewActive;
    IBOutlet NSLayoutConstraint *_constraintViewActiveExternalWidth;
    IBOutlet NSLayoutConstraint *_constraintViewActiveInternalWidth;
    
    
    IBOutlet NSLayoutConstraint *_constraintImageSelectedX;
    IBOutlet NSLayoutConstraint *_constraintImageSelectedW;
    IBOutlet UIImageView *_imageSelected;
    int _selectedElement;
}

- (void)setRating:(float)rating animated:(BOOL)animated;
- (void)setRatedState;

@end
