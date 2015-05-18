//
//  KLMapViewController.m
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLMapViewController.h"



@implementation KLMapAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.location.latitude.floatValue, self.location.longitude.floatValue);
}

@end



@implementation KLAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        KLMapAnnotation *a = annotation;
        
        UIImageView *imageBubble = [[UIImageView alloc] initWithFrame:CGRectMake(-108, -64, 216, 64)];
        [imageBubble setImage:[UIImage imageNamed:@"locationBubble"]];
        [self addSubview:imageBubble];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -13, 21, 26)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"location_pin"];
        [self addSubview:imageView];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(17, 14, 216 - 40, 20)];
        [labelName setFont:[UIFont systemFontOfSize:14]];
        [labelName setText:a.location.name];
        [imageBubble addSubview:labelName];
        
        
        UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(17, 31, 216 - 40, 20)];
        [labelAddress setFont:[UIFont systemFontOfSize:12]];
        [labelAddress setTextColor:[UIColor colorFromHex:0x8e9bb4]];
        [labelAddress setText:a.location.address];
        [imageBubble addSubview:labelAddress];
        
    }
    
    return self;
}

@end



@interface KLMapViewController () <UIActionSheetDelegate, MKMapViewDelegate>

@end



@implementation KLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KLMapAnnotation *annotation = [[KLMapAnnotation alloc] init];
    annotation.location = self.location;
    
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.location.latitude.floatValue, self.location.longitude.floatValue) addressDictionary:nil];
    _mapItem = [[MKMapItem alloc] initWithPlacemark:place];
    
    [_map addAnnotation:annotation];
    [_map setCenterCoordinate:CLLocationCoordinate2DMake(self.location.latitude.floatValue, self.location.longitude.floatValue) animated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    [self kl_setTitle:SFLocalized(@"locationHeader")
            withColor:[UIColor blackColor]];
    
    UIBarButtonItem *buttonShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"locationShare"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(onShare)];
    buttonShare.tintColor = [UIColor colorFromHex:0x6466ca];
    [self.navigationItem setRightBarButtonItem:buttonShare];
    
   
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onShare
{
    BOOL isChromeAvailable = [[UIApplication sharedApplication] canOpenURL:
                              [NSURL URLWithString:@"comgooglemaps://"]];
    UIActionSheet *actionSheet = nil;
    if (isChromeAvailable)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SFLocalized(@"locationCancel") destructiveButtonTitle:nil otherButtonTitles:SFLocalized(@"locationOpenInGoogleMaps"), SFLocalized(@"locationOpenInAppleMaps"), nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SFLocalized(@"locationCancel") destructiveButtonTitle:nil otherButtonTitles:SFLocalized(@"locationOpenInAppleMaps"), nil];
    }
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL isChromeAvailable = [[UIApplication sharedApplication] canOpenURL:
                              [NSURL URLWithString:@"comgooglemaps://"]];
    if (isChromeAvailable)
    {
        if (buttonIndex == 0) {
            NSString *string = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f", self.event.title, self.location.latitude.floatValue, self.location.longitude.floatValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }
        else if (buttonIndex == 1)
            [MKMapItem openMapsWithItems:[NSArray arrayWithObject:_mapItem] launchOptions:nil];
        
    }
    else
        [MKMapItem openMapsWithItems:[NSArray arrayWithObject:_mapItem] launchOptions:nil];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    KLAnnotationView *av = [[KLAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return av;
}

@end
