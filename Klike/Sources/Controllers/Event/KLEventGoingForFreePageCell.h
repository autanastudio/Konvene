//
//  KLEventGoingForFreePageCell.h
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



@class KLActivityIndicator;

@interface KLEventGoingForFreePageCell : KLEventPageCell {
    IBOutlet UIView *_viewMain;
    IBOutlet UIView *_viewActive;
    IBOutlet UIView *_viewInactive;
    
    KLActivityIndicator *_activity;
    
}

- (void)setActive:(BOOL)active;
- (void)setLoading:(BOOL)loading;

@end
