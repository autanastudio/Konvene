//
//  KLUserView.h
//  Klike
//
//  Created by admin on 26/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"

@class KLUserWrapper;

@interface KLUserView : UIView <KLParalaxHeaderView>
@property (weak, nonatomic) IBOutlet PFImageView *backImageView;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userFollowersButton;
@property (weak, nonatomic) IBOutlet UIButton *userFolowingButton;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *imagePhotoButton;

- (void)updateWithUser:(KLUserWrapper *)user;

@end
