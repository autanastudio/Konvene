//
//  KLSignUpViewController.h
//  Klike
//
//  Created by admin on 06/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLLoginFormViewController.h"

@interface KLSignUpViewController : KLLoginFormViewController

@property (nonatomic, assign) id<KLChildrenViewControllerDelegate> kl_parentViewController;

@end
