//
//  KLEventHeaderView.h
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"

@interface KLEventHeaderView : UIView <KLParalaxView> {
    
    IBOutlet UIImageView *_imageFake;
}

@property (weak, nonatomic) IBOutlet PFImageView *eventImageView;

- (void)configureWithEvent:(KLEvent *)event;
- (void)startAppearAnimation;

@end
