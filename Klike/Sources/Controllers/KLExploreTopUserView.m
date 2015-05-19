//
//  KLExploreTopUserTableViewCell.m
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreTopUserView.h"



@implementation KLExploreTopUserViewCollectionViewCell

- (void)awakeFromNib
{
    
}

- (void)buildWithEvent:(KLEvent *)event
{
    
}

@end



@implementation KLExploreTopUserView

+ (KLExploreTopUserView*)createTopUserView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KLExploreTopUserView" owner:nil options:nil] objectAtIndex:0];
}

- (void)buildWithUser:(id)user
{
    
}

- (void)awakeFromNib {
    // Initialization code
    [_collection registerNib:[UINib nibWithNibName:@"KLExploreTopUserViewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell"];
}

- (IBAction)onFollow:(id)sender {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLExploreTopUserViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}


@end
