//
//  KLTutorialPageViewController.h
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTutorialPageViewController : UIViewController

@property(nonatomic, assign) NSInteger index;

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages;

+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages;

@end
