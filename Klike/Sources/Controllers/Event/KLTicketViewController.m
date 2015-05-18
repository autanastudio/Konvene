//
//  KLTicketViewController.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTicketViewController.h"
#import "KLEventPaymentFinishedPageCell.h"



@interface KLTicketViewController ()

@end

@implementation KLTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _image.image = [[_eventImage scaleToFillSize:_image.frame.size] filteredImage];
    CGSize sz = _image.frame.size;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, sz.width, sz.height);
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"ticket_top_mask"] CGImage];
    _image.layer.mask = maskLayer;
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.dismissDirection = recognizer.direction;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
