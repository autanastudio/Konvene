//
//  KLGalleryImageCollectionViewCell.m
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLGalleryImageCollectionViewCell.h"

@implementation KLGalleryImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)runAnimtionFromFrame:(CGRect)rect completion:(void (^)())completion
{
    
    _constraintTop.constant = rect.origin.y;
    _constraintLeft.constant = rect.origin.x;
    _constraintHeigth.constant = rect.size.height;
    _constraintWidth.constant = rect.size.width;
    [_image layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.25
                     animations:^ {
                         _constraintTop.constant = 0;
                         _constraintLeft.constant = 0;
                         _constraintWidth.constant = self.frame.size.width;
                         _constraintHeigth.constant = self.frame.size.height;
                         [_image layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                         completion();
                     }];

}

- (void)runAnimtionToFrame:(CGRect)rect completion:(void (^)())completion
{
    [UIView animateWithDuration:0.25
                     animations:^ {
                         _constraintTop.constant = rect.origin.y;
                         _constraintLeft.constant = rect.origin.x;
                         _constraintWidth.constant = rect.size.width;
                         _constraintHeigth.constant = rect.size.height;
                         [_image layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)buildWithGalleryObject:(KLGalleryObject *)object
{
    _constraintTop.constant = 0;
    _constraintLeft.constant = 0;
    _constraintWidth.constant = self.frame.size.width;
    _constraintHeigth.constant = self.frame.size.height;
    [_image layoutIfNeeded];
    
    _image.file = object.photo;
    [_image loadInBackground];
}

- (UIImage *)imageForShare
{
    if (_image.file.isDataAvailable) {
        return _image.image;
    } else {
        return nil;
    }
}

@end
