//
//  KLEventListCell.h
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEventListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceBadge;

- (void)configureWithEvent:(KLEvent *)event;

@end
