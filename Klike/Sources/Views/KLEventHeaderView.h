//
//  KLEventHeaderView.h
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"

@interface KLEventHeaderView : UIView <KLParalaxView>

@property (weak, nonatomic) IBOutlet PFImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *eventSlashIcon;
@property (weak, nonatomic) IBOutlet UILabel *dresscodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDetails;

@end
