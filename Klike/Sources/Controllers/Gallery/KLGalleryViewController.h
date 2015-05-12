//
//  KLGalleryViewController.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"



@class KLEvent;



@interface KLGalleryViewController : KLViewController {
    
    IBOutlet UICollectionView *_collectionGrid;
    IBOutlet UICollectionView *_collectionPhotos;
}

@property (nonatomic) KLEvent *event;

@end
