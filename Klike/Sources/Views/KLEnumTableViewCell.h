//
//  KLEnumTableViewCell.h
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEnumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *seprator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;

- (void)configureWithEnumObject:(KLEnumObject *)enumObject;

@end
