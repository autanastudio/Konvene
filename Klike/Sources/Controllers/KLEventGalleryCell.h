//
//  KLEventGalleryCell.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



@class KLEvent;



@interface KLEventGalleryCell : KLEventPageCell <UICollectionViewDataSource, UICollectionViewDelegate>{
    
    IBOutlet UICollectionView *_collection;
}

- (void)reloadData;

@end
