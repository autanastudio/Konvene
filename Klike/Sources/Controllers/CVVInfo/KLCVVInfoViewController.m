//
//  KLCVVInfoViewController.m
//  Klike
//
//  Created by Katekov Anton on 01.06.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCVVInfoViewController.h"



@interface KLCVVInfoViewController ()

@end

@implementation KLCVVInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.alpha = 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)onClose:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

@end
