//
//  KLGalleryViewController.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLGalleryViewController.h"
#import "MWPhotoBrowser.h"
#import "MWGridViewController.h"



@interface KLMWPhoto : NSObject <MWPhoto>

@end



@implementation KLMWPhoto


- (UIImage *)underlyingImage
{
    return [UIImage imageNamed:@"test_bg"];
}

- (void)setUnderlyingImage:(UIImage *)underlyingImage
{}

- (void)loadUnderlyingImageAndNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void)performLoadUnderlyingImageAndNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void)unloadUnderlyingImage
{
    
}

- (void)cancelAnyLoading
{}

@end



@interface KLGalleryViewController ()

@property (nonatomic, strong) UILabel *customTitleLabel;

@end



@implementation KLGalleryViewController

- (void)viewDidLoad {
    
    self.delegate = self;
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

- (void)kl_setTitle:(NSString *)title
          withColor:(UIColor *)color
{
    if (!self.customTitleLabel) {
        self.title = @"";
        self.customTitleLabel = [[UILabel alloc] init];
        [self.customTitleLabel setText:title];
        [self.customTitleLabel setTextColor:color];
        [self.customTitleLabel setFont:[UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                        style:SFFontStyleMedium
                                                         size:17.]];
        [self.navigationItem setTitleView:self.customTitleLabel];
    }
//    self.customTitle = title;
    [self.customTitleLabel setText:title];
    [self.customTitleLabel sizeToFit];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 100;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [KLMWPhoto new];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    return [KLMWPhoto new];;
}

@end
