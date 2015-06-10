//
//  KLActivityEventGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityEventGroupCell.h"

@interface KLActivityEventGroupCell ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectonView;

@end

@implementation KLActivityEventGroupCell

- (void)awakeFromNib
{
    [self.collectonView registerClass:[KLActivityUserCollectionCell class]
           forCellWithReuseIdentifier:klUserCollectionCellReuseId];
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
    [self.collectonView reloadData];
}

+ (NSString *)reuseIdentifier
{
    return @"ActivityEventGroup";
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.activity.users.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLActivityUserCollectionCell *cell = [self.collectonView dequeueReusableCellWithReuseIdentifier:klUserCollectionCellReuseId forIndexPath:indexPath];
    KLUserWrapper *user  = [[KLUserWrapper alloc] initWithUserObject:self.activity.users[indexPath.row]];
    [cell configureWithuser:user];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLUserWrapper *user  = [[KLUserWrapper alloc] initWithUserObject:self.activity.users[indexPath.row]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityCell:showUserProfile:)]) {
        [self.delegate activityCell:self
                    showUserProfile:user];
    }
}

@end
