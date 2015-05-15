//
//  KLCardCell.h
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKCard;

@interface KLCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cardBGView;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

- (void)configureWithCard:(NSObject *)card;

@end
