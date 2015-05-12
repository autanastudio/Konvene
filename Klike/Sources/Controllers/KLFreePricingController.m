//
//  KLFreePricingController.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFreePricingController.h"

@interface KLFreePricingController ()

@end

@implementation KLFreePricingController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"FreePricingView" bundle:nil];
    self.pricingView = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    [self.view addSubview:self.pricingView];
    [self.pricingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                               excludingEdge:ALEdgeBottom];
}

- (NSString *)title
{
    return @"Free";
}

@end
