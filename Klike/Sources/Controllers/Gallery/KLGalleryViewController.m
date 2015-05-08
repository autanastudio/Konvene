//
//  KLGalleryViewController.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLGalleryViewController.h"




//@interface KLMWPhoto : NSObject <MWPhoto>
//
//@end



//@implementation KLMWPhoto
//
//
//- (UIImage *)underlyingImage
//{
//    return [UIImage imageNamed:@"test_bg"];
//}
//
//- (void)setUnderlyingImage:(UIImage *)underlyingImage
//{}
//
//- (void)loadUnderlyingImageAndNotify
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
//                                                        object:self];
//}
//
//- (void)performLoadUnderlyingImageAndNotify
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
//                                                        object:self];
//}
//
//- (void)unloadUnderlyingImage
//{
//    
//}
//
//- (void)cancelAnyLoading
//{}
//
//@end



@interface KLGalleryViewController ()

@property (nonatomic, strong) UILabel *customTitleLabel;

@end



@implementation KLGalleryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor blackColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0xffffff];
    [self kl_setTitle:SFLocalized(@"galleryHeader")
            withColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
