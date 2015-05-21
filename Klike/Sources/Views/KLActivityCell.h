//
//  KLActivityCell.h
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLActivityCell : UITableViewCell

@property (nonatomic, strong) KLActivity *activity;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

- (void)configureWithActivity:(KLActivity *)activity;

@end
