//
//  KLGalleryViewController.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"



@class KLEvent;
@class KLEventViewController;

@protocol KLGalleryViewControllerDelegate <NSObject>

- (void)reloadGallery;

@end



@interface KLGalleryViewController : KLViewController {
    
    IBOutlet UICollectionView *_collectionGrid;
    IBOutlet UICollectionView *_collectionPhotos;
    
    
    IBOutlet UIButton *_buttonTiles;
    IBOutlet UIImageView *_imageTiles;
    
    IBOutlet UILabel *_labelCount;
}

@property (nonatomic) KLEvent *event;
@property (nonatomic) NSNumber *photoIndex;
@property (nonatomic, weak) id<KLGalleryViewControllerDelegate> eventDelegate;

@end
