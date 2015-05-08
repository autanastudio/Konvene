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

- (void)configureWithEvent:(KLEvent *)event;

@end
