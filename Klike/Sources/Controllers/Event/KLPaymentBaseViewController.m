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
#import "KLCreateCardView.h"



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
    KLCreateCardView *cardView = [KLCreateCardView createCardView];
    _viewCardInternal = cardView;
    [cardView setTextTintColor:[UIColor whiteColor]];
    [_viewCard addSubview:cardView];
    cardView.backgroundColor = [UIColor clearColor];
    [cardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    
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
        
        
        cardView.placeholderColor = [UIColor colorFromHex:0x588fe1];
        cardView.linesColor = [UIColor colorFromHex:0x588fe1];
        _labelAmount.text = [@"$" stringByAppendingString:self.event.price.pricePerPerson.description];
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
        
        
        cardView.placeholderColor = [UIColor colorFromHex:0x15badd];
        cardView.linesColor = [UIColor colorFromHex:0x15badd];
        _labelAmount.text = [@"$" stringByAppendingString:self.event.price.minimumAmount.description];
    }
    cardView.textColor = [UIColor whiteColor];
    cardView.buttonTintColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _constraintBottom.constant = kbSize.height;
    [self.view layoutIfNeeded];
   
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    _constraintBottom.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onClose:(id)sender
{
    [self onBackground:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onBackground:(id)sender
{
    [_viewCardInternal resignFirstResponder];
    [_viewNumberAmount resignFirstResponder];
    [_viewPriceAmount resignFirstResponder];
}

- (IBAction)onThrowIn:(id)sender
{
    if (self.event.price.pricingType.intValue == KLEventPricingTypePayed)
    {
        if (_viewNumberAmount.number < 1)
            return;
    }
    else
    {
        if (_viewPriceAmount.number.floatValue < 1)
            return;
    }
    
    
    __weak KLPaymentBaseViewController *__wealSelf = self;
    [[KLAccountManager sharedManager] addCard:_viewCardInternal.card
                             withCompletition:^(id object, NSError *error) {
                                 if (!error) {
                                     KLEventPrice *price = self.event.price;
                                     KLEventPricingType priceType = price.pricingType.intValue;
                                     
                                     if (priceType == KLEventPricingTypePayed) {
                                         [[KLEventManager sharedManager] buyTickets:@(_viewNumberAmount.number)
                                                                               card:object
                                                                           forEvent:self.event
                                                                       completition:^(id object, NSError *error) {
                                                                           [__wealSelf onClose:nil];
                                                                       }];
                                     }
                                     else if (priceType == KLEventPricingTypeThrow) {
                                         [[KLEventManager sharedManager] payAmount:_viewPriceAmount.number
                                                                              card:object
                                                                          forEvent:self.event
                                                                      completition:^(id object, NSError *error) {
                                                                          [__wealSelf onClose:nil];
                                                                          }];
                                     }
                                     
                                 }
                                 else {

                                 }

                             }];
    
}

@end
