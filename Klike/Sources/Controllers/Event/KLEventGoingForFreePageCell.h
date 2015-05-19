//
//  KLEventGoingForFreePageCell.h
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"

@interface KLEventGoingForFreePageCell : KLEventPageCell {
    IBOutlet UIView *_viewActive;
    IBOutlet UIView *_viewInactive;
}

- (void)setActive:(BOOL)active;

@end
