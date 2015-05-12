//
//  KLEventGalleryCollectionViewCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGalleryCollectionViewCell.h"

@implementation KLEventGalleryCollectionViewCell

- (void)buildWithImage:(PFFile*)image
{
    self.imageobject = image;
    if (!image) {
        _image.image = [UIImage imageNamed:@"event_galery_plus"];
        _image.contentMode = UIViewContentModeCenter;
        return;
    }
    
    _image.file = image;
    [_image loadInBackground];
    _image.contentMode = UIViewContentModeScaleAspectFill;
}

@end
