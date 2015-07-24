//
//  KLExplorePeopleCell.h
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLExplorePeopleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (nonatomic, strong) KLUserWrapper *user;

- (void)configureWithUser:(KLUserWrapper *)user;

@end
