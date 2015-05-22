//
//  KLExploreTopUserTableViewCell.h
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KLEvent;



@interface KLExploreTopUserViewCollectionViewCell : UICollectionViewCell {
    
    IBOutlet PFImageView *_image;
}

- (void)buildWithEvent:(KLEvent*)event;

@end



@interface KLExploreTopUserView : UIView <UICollectionViewDataSource> {
    
    IBOutlet PFImageView *_imageAvatar;
    IBOutlet UILabel *_labelName;
    IBOutlet UIButton *_buttonFollow;
    IBOutlet UILabel *_labelEventsNumber;
    IBOutlet UILabel *_labelEventsText;
    IBOutlet UILabel *_labelFollowersNumber;
    IBOutlet UILabel *_labelFollowersText;
    IBOutlet UICollectionView *_collection;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

+ (KLExploreTopUserView*)createTopUserView;
- (void)buildWithUser:(KLUserWrapper *)user;

@end
