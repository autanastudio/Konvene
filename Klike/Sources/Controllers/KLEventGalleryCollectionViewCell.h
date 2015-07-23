//
//  KLEventGalleryCollectionViewCell.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class PFImageView;



@interface KLEventGalleryCollectionViewCell : UICollectionViewCell {
    
    IBOutlet PFImageView *_image;
}

@property (nonatomic)id imageobject;

- (void)buildWithGalleryObject:(KLGalleryObject *)object;

@end
