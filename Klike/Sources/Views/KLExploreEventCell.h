//
//  KLExploreEventCell.h
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLExploreEventCell;

@protocol KLExploreEventCellDelegate <NSObject>

- (void)exploreEventCell:(KLExploreEventCell *)cell
   showAttendiesForEvent:(KLEvent *)event;

@end

@interface KLExploreEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *slashImageView;
@property (weak, nonatomic) IBOutlet UILabel *dressCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceBadge;
@property (weak, nonatomic) IBOutlet UIButton *attendiesButton;
@property (weak, nonatomic) IBOutlet UILabel *attendiesCountLabel;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *attendies;

@property (nonatomic, weak) id<KLExploreEventCellDelegate> delegate;

- (void)configureWithEvent:(KLEvent *)event;

@end
