//
//  KLActivityCell.h
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLActivityCell;

@protocol KLActivityCellDelegate <NSObject>

- (void)activityCell:(KLActivityCell *)cell
     showUserProfile:(KLUserWrapper *)user;

@end

static NSString *klUserCollectionCellReuseId = @"klUserCollectionCellReuseId";

@interface KLActivityUserCollectionCell : UICollectionViewCell

@property (nonatomic, strong) PFImageView *userImageView;

- (void)configureWithuser:(KLUserWrapper *)user;

@end

@interface KLActivityCell : UITableViewCell

@property (nonatomic, strong) KLActivity *activity;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) id<KLActivityCellDelegate> delegate;

- (void)configureWithActivity:(KLActivity *)activity;
+ (NSString *)reuseIdentifier;

@end
