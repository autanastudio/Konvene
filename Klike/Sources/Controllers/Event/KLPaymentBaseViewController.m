//
//  KLPaymentBaseViewController.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPaymentBaseViewController.h"
#import "KLPaymentNumberAmountView.h"
#import "KLPaymentPriceAmountView.h"



@interface KLPaymentBaseViewController ()

@end

@implementation KLPaymentBaseViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!_throwInStyle)
    {
        self.view.backgroundColor = [UIColor colorFromHex:0x2c62b4];
        _color = [UIColor colorFromHex:0x6466ca];
        _imageBackground.image = [UIImage imageNamed:@"p_btn_buy_ticket"];
        _imageBackground1.image = [UIImage imageNamed:@"p_btn_buy_ticket"];
        _imageBackground2.image = [UIImage imageNamed:@"p_btn_buy_ticket"];
        _labelAmountDescription.text = @"per ticket";
        _labelAmount.text = @"$40";
        _labelAmount.textColor = [UIColor colorFromHex:0x346bbd];
        [_button setImage:[UIImage imageNamed:@"p_ic_ticket"] forState:UIControlStateNormal];
        [_button setTitle:@"Buy Tickets" forState:UIControlStateNormal];
        
        _viewNumberAmount = [KLPaymentNumberAmountView paymentNumberAmountView];
        [_viewInputConyeny addSubview:_viewNumberAmount];
        [_viewNumberAmount autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        _labelHeader.text = @"BUY TICKETS";
    }
    else
    {
        self.view.backgroundColor = [UIColor colorFromHex:0x0388a6];
        _color = [UIColor colorFromHex:0x0494b3];
        _imageBackground.image = [UIImage imageNamed:@"p_btn_throw_in"];
        _imageBackground1.image = [UIImage imageNamed:@"p_btn_throw_in"];
        _imageBackground2.image = [UIImage imageNamed:@"p_btn_throw_in"];
        _labelAmountDescription.text = @"gathered";
        _labelAmount.text = @"$40";
        _labelAmount.textColor = [UIColor colorFromHex:0x0494b3];
        [_button setImage:[UIImage imageNamed:@"p_ic_throw_in"] forState:UIControlStateNormal];
        [_button setTitle:@"Throw In" forState:UIControlStateNormal];
        
        
        _viewPriceAmount = [KLPaymentPriceAmountView priceAmountView];
        [_viewInputConyeny addSubview:_viewPriceAmount];
        [_viewPriceAmount autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _viewPriceAmount.minimum = [NSDecimalNumber decimalNumberWithString:@"0"];
        
        _labelHeader.text = @"THROW IN";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}


- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _constraintBottom.constant = kbSize.height;
    [self.view layoutIfNeeded];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
