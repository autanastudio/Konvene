//
//  KLEventGalleryCell.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventGalleryCell.h"
#import "KLEventGalleryCollectionViewCell.h"



@implementation KLEventGalleryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collection registerNib:[UINib nibWithNibName:@"KLEventGalleryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLEventGalleryCollectionViewCell"];
}

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KLEventGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLEventGalleryCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
        [cell buildWithImage:nil];
    else
        [cell buildWithImage:indexPath];
    
    return cell;
}

@end
