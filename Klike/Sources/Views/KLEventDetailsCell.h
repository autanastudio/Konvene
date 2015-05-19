//
//  KLEventDetailsCell.h
//  Klike
//
//  Created by admin on 04/05/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"

@interface KLEventDetailsCell : KLEventPageCell

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *slashImageView;
@property (weak, nonatomic) IBOutlet UILabel *dressCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *attendiesButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UILabel *attendiesCountLabel;
@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *attendies;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *privateIcon;

@end
