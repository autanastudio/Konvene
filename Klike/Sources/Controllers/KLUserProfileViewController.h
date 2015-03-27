//
//  KLUserProfileViewController.h
//  Klike
//
//  Created by admin on 25/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLUserWrapper;

@interface KLUserProfileViewController : UIViewController

- (instancetype)initWithUser:(KLUserWrapper *)user;

@end
