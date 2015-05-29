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
    
    [_buttonAddPhotos setTitleColor:[UIColor colorFromHex:0x6466ca] forState:UIControlStateNormal];
}

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    [self reloadData];
}

- (IBAction)onAddPhotos:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(galleryCellAddImageDidPress)]) {
        [self.delegate performSelector:@selector(galleryCellAddImageDidPress) withObject:nil];
    }
}

- (void)reloadData
{
    if (self.event.extension.photos.count > 0)
    {
        [_collection reloadData];
        _collection.hidden = NO;
        _buttonAddPhotos.hidden = YES;
    }
    else
    {
        _collection.hidden = YES;
        _buttonAddPhotos.hidden = NO;
    }
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.event.extension.photos.count+ 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLEventGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLEventGalleryCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
        [cell buildWithImage:nil];
    else
        [cell buildWithImage:[self.event.extension.photos objectAtIndex:indexPath.row - 1]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
   
    KLEventGalleryCollectionViewCell *cell = (KLEventGalleryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageobject)
    {
        if ([self.delegate respondsToSelector:@selector(galleryCellDidPress:)]) {
            [self.delegate performSelector:@selector(galleryCellDidPress:) withObject:cell.imageobject];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(galleryCellAddImageDidPress)]) {
            [self.delegate performSelector:@selector(galleryCellAddImageDidPress) withObject:nil];
        }
    }
   
    
}


@end
