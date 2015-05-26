//
//  KLExplorePeopleTopCell.h
//  Klike
//
//  Created by Alexey on 5/26/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleCell.h"

@class KLEvent;

@interface KLExploreTopUserViewCollectionViewCell : UICollectionViewCell {
    
    IBOutlet PFImageView *_image;
}

- (void)buildWithEvent:(KLEvent*)event;

@end

@interface KLExplorePeopleTopCell : KLExplorePeopleCell

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
