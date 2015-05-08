//
//  KLEventListCell.h
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLEventListCell;

@protocol KLEventListCellDelegate <NSObject>

- (void)eventListCell:(KLEventListCell *)cell
showAttendiesForEvent:(KLEvent *)event;

@end

@interface KLEventListCell : UITableViewCell

@property (weak, nonatomic) id<KLEventListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet PFImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceBadge;
@property (weak, nonatomic) IBOutlet UIButton *attendiesButton;
@property (weak, nonatomic) IBOutlet UILabel *attendiesCountLabel;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *attendies;

- (void)configureWithEvent:(KLEvent *)event;

@end
