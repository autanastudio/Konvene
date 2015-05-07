//
//  KLEventGalleryCollectionViewCell.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEventGalleryCollectionViewCell : UICollectionViewCell {
    
    IBOutlet UIImageView *_image;
}

- (void)buildWithImage:(id)image;

@end
