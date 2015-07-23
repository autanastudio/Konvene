//
//  KLGalleryImageCollectionViewCell.h
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLGalleryImageCollectionViewCell : UICollectionViewCell {
    
    IBOutlet PFImageView *_image;
    
    IBOutlet NSLayoutConstraint *_constraintTop;
    IBOutlet NSLayoutConstraint *_constraintLeft;
    IBOutlet NSLayoutConstraint *_constraintWidth;
    IBOutlet NSLayoutConstraint *_constraintHeigth;
    
}

@property (nonatomic, strong, readonly) UIImage *imageForShare;

- (void)runAnimtionFromFrame:(CGRect)rect completion:(void (^)())completion;
- (void)runAnimtionToFrame:(CGRect)rect completion:(void (^)())completion;
- (void)buildWithGalleryObject:(KLGalleryObject *)object;

@end
