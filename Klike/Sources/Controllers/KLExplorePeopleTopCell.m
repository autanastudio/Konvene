//
//  KLExplorePeopleTopCell.m
//  Klike
//
//  Created by Alexey on 5/26/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleTopCell.h"

@implementation KLExploreTopUserViewCollectionViewCell

- (void)awakeFromNib
{
    
}

- (void)buildWithEvent:(KLEvent *)event
{
    if (event.backImage) {
        _image.file = event.backImage;
        [_image loadInBackground];
    }else {
        _image.image = [UIImage imageNamed:@"event_pic_placeholder"];
    }
}

@end

@interface KLExplorePeopleTopCell ()

@property (nonatomic, strong) NSArray *events;

@end

@implementation KLExplorePeopleTopCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.collection registerNib:[UINib nibWithNibName:@"KLExploreTopUserViewCollectionViewCell" bundle:nil]
      forCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell"];
    
//    UICollectionViewFlowLayout *flowLayout = self.collection.collectionViewLayout;
//    CGRect screenSize = [UIScreen mainScreen].bounds;
//    flowLayout
}

- (void)configureWithUser:(KLUserWrapper *)user
{
    [super configureWithUser:user];
    
    self.events = [NSArray array];
    __weak typeof(self) weakSelf = self;
    PFQuery *query = [[KLEventManager sharedManager] getCreatedEventsQueryForUser:self.user];
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.events = objects;
            [weakSelf.collection reloadData];
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLExploreTopUserViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell" forIndexPath:indexPath];
    [cell buildWithEvent:self.events[indexPath.row]];
    
    return cell;
}

@end
