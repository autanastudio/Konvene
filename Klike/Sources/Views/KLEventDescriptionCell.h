//
//  KLEventDescriptionCell.h
//  Klike
//
//  Created by admin on 04/05/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"

@interface KLEventDescriptionCell : KLEventPageCell {
    
    IBOutlet NSLayoutConstraint *_constraintNameY;
    IBOutlet UILabel *_labelCreator;
}

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
