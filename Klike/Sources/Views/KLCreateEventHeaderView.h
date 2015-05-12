//
//  KLCreateEventHeaderView.h
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"


@interface KLCreateEventHeaderView : UIView <KLParalaxView>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

- (void)setBackImage:(UIImage *)backImage;
- (void)setLoadableBackImage:(PFFile *)backImage;

@end
