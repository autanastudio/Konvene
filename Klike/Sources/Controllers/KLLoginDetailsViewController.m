//
//  KLLoginDetailsViewController.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginDetailsViewController.h"

@interface KLLoginDetailsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@end

static CGFloat klHalfSizeofImage = 32.;

@implementation KLLoginDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self kl_setNavigationBarColor:nil];
    
    CALayer *imageLayer = self.userImageView.layer;
    [imageLayer setCornerRadius:klHalfSizeofImage];
    [imageLayer setMasksToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"DETAILS")];
    [self kl_setNavigationBarTitleColor:[UIColor blackColor]];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Actions

- (IBAction)onSubmit:(id)sender
{
    
}

- (IBAction)onUserPhoto:(id)sender
{
    
}

- (IBAction)onLocation:(id)sender
{
    
}

@end
