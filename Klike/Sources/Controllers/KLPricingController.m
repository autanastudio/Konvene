//
//  KLPricingController.m
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPricingController.h"
#import "KLFreePricingController.h"
#import "KLPayedPricingController.h"
#import "KLThrowPricingController.h"

@interface KLPricingController ()

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) NSArray *childControllers;

@end

@implementation KLPricingController

- (instancetype)init
{
    if (self = [super init]) {
        KLFreePricingController *free = [[KLFreePricingController alloc] init];
        KLPayedPricingController *payed = [[KLPayedPricingController alloc] init];
        KLThrowPricingController *throw = [[KLThrowPricingController alloc] init];
        _childControllers = @[free, payed, throw];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorFromHex:0x6465c6]];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back"]
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"event_right_arr_whight"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onNext)];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:SFLocalized(@"PRICING") withColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - Action

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onNext
{
    
}

@end
