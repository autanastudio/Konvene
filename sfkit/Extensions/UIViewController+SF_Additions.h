//
//  UIViewController+SF_Additions.h
//  Livid
//
//  Created by Yarik Smirnov on 14/12/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SF_Additions)

/**
 *  Embed self in UINavigationController;
 *
 *  @return UINavigationController instanse with self as root viewController
 */
- (UINavigationController *)embedInNavigationController;

@end
