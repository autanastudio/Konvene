//
//  KLGalleryGridCollectionViewCell.h
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLGalleryGridCollectionViewCell : UICollectionViewCell {
    IBOutlet PFImageView *_image;
}

- (void)buildWithGalleryObject:(KLGalleryObject *)object;

@end
