//
//  KLSettingsHeaderView.h
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"

@interface KLSettingsHeaderView : UIView <KLParalaxView>

@property (weak, nonatomic) IBOutlet PFImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *backPhotoButton;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;

- (void)updateWithUser:(KLUserWrapper *)user;

@end
