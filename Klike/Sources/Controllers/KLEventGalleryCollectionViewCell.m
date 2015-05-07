//
//  KLEventGalleryCollectionViewCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGalleryCollectionViewCell.h"

@implementation KLEventGalleryCollectionViewCell

- (void)buildWithImage:(id)image
{
    self.imageobject = image;
    if (!image) {
        _image.image = [UIImage imageNamed:@"event_galery_plus"];
        _image.contentMode = UIViewContentModeCenter;
        return;
    }
    
    _image.image = [UIImage imageNamed:@"test_bg"];
    _image.contentMode = UIViewContentModeScaleAspectFill;
}

@end
