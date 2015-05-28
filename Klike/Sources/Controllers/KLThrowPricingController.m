//
//  KLThrowPricingController.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLThrowPricingController.h"

@interface KLThrowPricingController ()

@property (nonatomic, strong) UIScrollView *scrolleView;

@end

@implementation KLThrowPricingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrolleView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrolleView];
    [self.scrolleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.scrolleView.alwaysBounceVertical = YES;
    self.scrolleView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UINib *nib = [UINib nibWithNibName:@"ThrowPricingView" bundle:nil];
    self.pricingView = [nib instantiateWithOwner:nil
                                          options:nil].firstObject;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.scrolleView addSubview:self.pricingView];
    [self.pricingView autoSetDimension:ALDimensionWidth toSize:screenSize.width];
    [self.pricingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (NSString *)title
{
    return @"Throw in";
}

@end
