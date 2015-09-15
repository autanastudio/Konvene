//
//  UIViewController+SF_Additions.m
//  Livid
//
//  Created by Yarik Smirnov on 14/12/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import "UIViewController+SF_Additions.h"

@implementation UIViewController (SF_Additions)

- (instancetype)embedInNavigationController
{
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:self];
    return navCtrl;
}

@end
