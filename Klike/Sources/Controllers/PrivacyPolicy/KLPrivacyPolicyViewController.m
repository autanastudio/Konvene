//
//  KLPrivacyPolicyViewController.m
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPrivacyPolicyViewController.h"



@interface KLPrivacyPolicyViewController ()

@end

@implementation KLPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    [self kl_setTitle:SFLocalized(@"provacyHeader")
            withColor:[UIColor blackColor]  spacing:@0.4];
    NSURLRequest *r = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://konveneapp.com/privacy.html"]];
    [_webView loadRequest:r];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
