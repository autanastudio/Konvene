//
//  KLTicketViewController.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTicketViewController.h"
#import "KLEventPaymentFinishedPageCell.h"
#import "DateTools.h"



@interface KLTicketViewController ()

@end

@implementation KLTicketViewController


- (UIImage*)ticketImage:(UIImage *)image
{
    UIImage *bigTicketIMage = [UIImage imageNamed:@"ticket_top"];
    CGSize ticketSize = bigTicketIMage.size;
    
    UIGraphicsBeginImageContextWithOptions(ticketSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, ticketSize.width, ticketSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIImage *rawImageData = [[CIImage alloc] initWithCGImage:newImage.CGImage];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIDotScreen"];
    [filter setDefaults];
    
    [filter setValue:rawImageData forKey:@"inputImage"];
    NSNumber *width = @(4.);
    NSNumber *angle = @(76.6);
    NSNumber *sharpness = @(0.7);
    [filter setValue:width
              forKey:@"inputWidth"];
    [filter setValue:angle
              forKey:@"inputAngle"];
    [filter setValue:sharpness
              forKey:@"inputSharpness"];
    
    CIImage *filteredImageData = [filter valueForKey:@"outputImage"];
    
    CIFilter *adjustFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [adjustFilter setValue:filteredImageData forKey:@"inputImage"];
    [adjustFilter setValue:@(0.5) forKey:@"inputPower"];
    
    filteredImageData = [adjustFilter valueForKey:@"outputImage"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGRect rect = [filteredImageData extent];
    CGImageRef cgImage = [context createCGImage:filteredImageData fromRect:rect];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage
                                           scale:scale
                                     orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    rect = CGRectZero;
    rect.size = ticketSize;
    UIGraphicsBeginImageContextWithOptions(ticketSize, NO, 0.0);
    [bigTicketIMage drawInRect:CGRectMake(0, 0, ticketSize.width, ticketSize.height)];
    [uiImage drawInRect:CGRectMake(0, 0, ticketSize.width, ticketSize.height) blendMode:kCGBlendModeMultiply alpha:1.];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _image.image = [self ticketImage:_eventImage];
    CGSize sz = _image.frame.size;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, sz.width, sz.height);
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"ticket_top_mask"] CGImage];
    _image.layer.mask = maskLayer;
    
    _labelEventName.text = _event.title;
    _labeCost.text = [NSString stringWithFormat:@"$%d", (int)_event.price.pricePerPerson.floatValue * [[KLEventManager sharedManager] boughtTicketsForEvent:self.event].intValue];
    _labelTicketNumber.text = [NSString stringWithFormat:@"%d Tickets", [[KLEventManager sharedManager] boughtTicketsForEvent:self.event].intValue];
    
    if (_event.location) {

//        KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
        
        KLLocation *eventVenue = [[KLLocation alloc] initWithObject:self.event.location];
        
//        PFObject *userPlace = currentUser.place;
//        KLLocation *userVenue = [[KLLocation alloc] initWithObject:currentUser.place];
//        CLLocationDistance distance = [userVenue distanceTo:eventVenue];
//        NSString *milesString = [NSString stringWithFormat:SFLocalized(@"event.location.distance"), distance*0.000621371];//Convert to miles
        _labelDistance.text = eventVenue.name;
        
    }
    else {
        _imagePin.hidden = YES;
        _labelDistance.hidden = YES;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [self updateTime:nil];
    
    if (self.event.isPastEvent)
    {
        CGAffineTransform tr = CGAffineTransformMakeRotation(-0.02);
        tr = CGAffineTransformTranslate(tr, 0, -8);
        _viewTop.transform = tr;
        
        
        tr = CGAffineTransformMakeRotation(0.02);
        tr = CGAffineTransformTranslate(tr, -2, 0);
        _viewBottom.transform = tr;
        
        _viewBottom.layer.borderWidth = 3;
        _viewBottom.layer.borderColor = [UIColor clearColor].CGColor;
        _viewBottom.layer.shouldRasterize = YES;
        
        _viewTop.layer.borderWidth = 3;
        _viewTop.layer.borderColor = [UIColor clearColor].CGColor;
        _viewTop.layer.shouldRasterize = YES;
    }
    
    self.view.alpha = 0.0;
}

- (void)updateTime:(NSTimer*)sender
{
    NSString *text = @"Right now!";
    int hours = [_event.startDate hoursLaterThan:[NSDate date]];
    if (hours > 0) {
        if (hours > 24) {
            int days = hours / 24;
            hours = hours % 24;
            text = [NSString stringWithFormat:@"%dd %dh", days, hours];
        }
        else
        {
            int minutes = [_event.startDate minutesLaterThan:[NSDate date]];
            minutes = minutes % 60;
            text = [NSString stringWithFormat:@"%dh %dm", hours, minutes];
        }
    }
    
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    //    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    //    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    //    NSString *timeBefore = [dateFormatter stringFromDate:_event.startDate];
    _labelTime.text = text;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)onClose:(id)sender {
    [_timer invalidate];
    _timer = nil;
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
