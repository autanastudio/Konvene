//
//  KLGalleryViewController.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLGalleryViewController.h"
#import "KLGalleryGridCollectionViewCell.h"
#import "KLGalleryImageCollectionViewCell.h"
#import "KLEventViewController.h"



@interface KLGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    BOOL _isGridState;
    
}

@end



@implementation KLGalleryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _isGridState = YES;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 12;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_collectionGrid.collectionViewLayout;
    layout.itemSize = CGSizeMake(w / 4, w/4);
    
    layout = (UICollectionViewFlowLayout*)_collectionPhotos.collectionViewLayout;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120);
    
    [_collectionGrid registerNib:[UINib nibWithNibName:@"KLGalleryGridCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLGalleryGridCollectionViewCell"];
    [_collectionPhotos registerNib:[UINib nibWithNibName:@"KLGalleryImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLGalleryImageCollectionViewCell"];
    
    _labelCount.text = [NSString stringWithFormat:@"%d photos", (int)self.event.extension.photos.count];
    
    if (_photoIndex) {
        [self transitToPhotosView:[NSIndexPath indexPathForRow:_photoIndex.intValue inSection:0] animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor blackColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0xffffff];
    [self kl_setTitle:SFLocalized(@"galleryHeader")
            withColor:[UIColor whiteColor] spacing:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onBack
{
    if (!_isGridState && !_photoIndex) {
        NSIndexPath *path = [[_collectionPhotos indexPathsForVisibleItems] lastObject];
        [self transitToGridView:path];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.event.extension.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionGrid)
    {
        KLGalleryGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLGalleryGridCollectionViewCell" forIndexPath:indexPath];
        [cell buildWithImage:[self.event.extension.photos objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        KLGalleryImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLGalleryImageCollectionViewCell" forIndexPath:indexPath];
        [cell buildWithImage:[self.event.extension.photos objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (collectionView == _collectionGrid)
    {
        [self transitToPhotosView:indexPath];
    }
    else
    {
        [self transitToGridView:indexPath];
    }
}

- (void)transitToPhotosView:(NSIndexPath*)indexPath
{
    if (!_isGridState) {
        return;
    }
    _isGridState = NO;
    _collectionPhotos.userInteractionEnabled = NO;
    _collectionGrid.userInteractionEnabled = NO;
    _collectionPhotos.hidden = NO;
    _collectionPhotos.alpha = 0;
    [_collectionPhotos setContentOffset:CGPointMake(_collectionPhotos.frame.size.width * indexPath.row, 0) animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _collectionPhotos.alpha = 1;
        UICollectionViewCell *cellFrom = [_collectionGrid cellForItemAtIndexPath:indexPath];
        KLGalleryImageCollectionViewCell *cellTo = (KLGalleryImageCollectionViewCell*)[_collectionPhotos cellForItemAtIndexPath:indexPath];
        CGRect r = [cellTo convertRect:cellFrom.bounds fromView:cellFrom];
        
        [cellTo runAnimtionFromFrame:r completion:^{
            _collectionGrid.hidden = YES;
            
            _collectionPhotos.userInteractionEnabled = YES;
            _collectionGrid.userInteractionEnabled = YES;
        }];
        
        _buttonTiles.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            _labelCount.alpha = 1;
            _imageTiles.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        
    });
    
}

- (void)transitToPhotosView:(NSIndexPath*)indexPath animated:(BOOL)animated
{
    if (!_isGridState) {
        return;
    }
    _isGridState = NO;
    if (animated) {
        [self transitToGridView:indexPath];
        return;
    }
    _collectionPhotos.userInteractionEnabled = NO;
    _collectionGrid.userInteractionEnabled = NO;
    _collectionPhotos.hidden = NO;
    _collectionPhotos.alpha = 0;
    [_collectionPhotos setContentOffset:CGPointMake(_collectionPhotos.frame.size.width * indexPath.row, 0) animated:NO];
    
    
    _collectionPhotos.alpha = 1;
    UICollectionViewCell *cellFrom = [_collectionGrid cellForItemAtIndexPath:indexPath];
    KLGalleryImageCollectionViewCell *cellTo = (KLGalleryImageCollectionViewCell*)[_collectionPhotos cellForItemAtIndexPath:indexPath];
    CGRect r = [cellTo convertRect:cellFrom.bounds fromView:cellFrom];
    
    [cellTo runAnimtionFromFrame:r completion:^{
    }];
    
    _collectionGrid.hidden = YES;
    
    _collectionPhotos.userInteractionEnabled = YES;
    _collectionGrid.userInteractionEnabled = YES;
    
    _labelCount.alpha = 1;
    _imageTiles.alpha = 1;
    _buttonTiles.hidden = NO;
}

- (void)transitToGridView:(NSIndexPath*)indexPath
{
    if (_isGridState) {
        return;
    }
    _isGridState = YES;
    
    _collectionPhotos.userInteractionEnabled = NO;
    _collectionGrid.userInteractionEnabled = NO;
    
    _collectionGrid.hidden = NO;
    [_collectionPhotos setContentOffset:CGPointMake(_collectionPhotos.frame.size.width * indexPath.row, 0) animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UICollectionViewCell *cellFrom = [_collectionGrid cellForItemAtIndexPath:indexPath];
        KLGalleryImageCollectionViewCell *cellTo = (KLGalleryImageCollectionViewCell*)[_collectionPhotos cellForItemAtIndexPath:indexPath];
        CGRect r = [cellTo convertRect:cellFrom.bounds fromView:cellFrom];
        
        [cellTo runAnimtionToFrame:r completion:^{
            _collectionPhotos.hidden = YES;
            
            _collectionPhotos.userInteractionEnabled = YES;
            _collectionGrid.userInteractionEnabled = YES;
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            _labelCount.alpha = 0;
            _imageTiles.alpha = 0;
        } completion:^(BOOL finished) {
            _buttonTiles.hidden = YES;
        }];
        
        
    });
}

- (IBAction)onTiles:(id)sender
{
    if (_isGridState) {
        return;
    }
    
    NSIndexPath *index = [[_collectionPhotos indexPathsForVisibleItems] firstObject];
    [self transitToGridView:index];
}

- (IBAction)onPlus:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SFLocalized(@"locationCancel") destructiveButtonTitle:nil otherButtonTitles:SFLocalized(@"evetnAddPhotoTake"), SFLocalized(@"evetnAddPhotoLibrary"), nil];
    self.imagePickerSheet = actionSheet;
    [actionSheet showInView:self.view];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
    
    [[KLEventManager sharedManager] addToEvent:self.event image:image completition:^(BOOL succeeded, NSError *error) {
        _labelCount.text = [NSString stringWithFormat:@"%d photos", (int)self.event.extension.photos.count];
        [_collectionPhotos reloadData];
        [_collectionGrid reloadData];
        [self.eventDelegate reloadGallery];
    }];
    
}

@end
