//
//  KLPayedPricingController.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPayedPricingController.h"

@interface KLPayedPricingController ()

@end

@implementation KLPayedPricingController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PayedPricingView" bundle:nil];
    self.pricingView = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    [self.view addSubview:self.pricingView];
    self.pricingView.processing = 0.02;//TODO get value from server
    [self.pricingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                               excludingEdge:ALEdgeBottom];
}

- (NSString *)title
{
    return @"Fixed Price";
}

@end
