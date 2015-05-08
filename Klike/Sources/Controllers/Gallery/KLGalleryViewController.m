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



@interface KLGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end



@implementation KLGalleryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 12;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_collectionGrid.collectionViewLayout;
    layout.itemSize = CGSizeMake(w / 4, w/4);
    
    layout = (UICollectionViewFlowLayout*)_collectionPhotos.collectionViewLayout;
    layout.itemSize = CGSizeMake(w, [UIScreen mainScreen].bounds.size.height - 100);
    
    [_collectionGrid registerNib:[UINib nibWithNibName:@"KLGalleryGridCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLGalleryGridCollectionViewCell"];
    [_collectionPhotos registerNib:[UINib nibWithNibName:@"KLGalleryImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLGalleryImageCollectionViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor blackColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0xffffff];
    [self kl_setTitle:SFLocalized(@"galleryHeader")
            withColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionGrid)
        return 20;
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionGrid)
    {
        KLGalleryGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLGalleryGridCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        KLGalleryImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLGalleryImageCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (collectionView == _collectionGrid)
    {
        
    }
    else
    {
        
    }
}

@end
