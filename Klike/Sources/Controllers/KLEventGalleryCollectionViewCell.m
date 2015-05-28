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
        _image.backgroundColor = [UIColor clearColor];
    }else {
        _image.image = nil;
        _image.file = image;
        [_image loadInBackground];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.backgroundColor = [UIColor colorFromHex:0x262638];
    }
}

@end
