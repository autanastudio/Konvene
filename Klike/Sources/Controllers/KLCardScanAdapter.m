//
//  KLCardScanAdapter.m
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCardScanAdapter.h"
#import "KLCreateCardView.h"

@interface KLCardScanAdapter ()

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, weak) KLCreateCardView *cardView;

@end

@implementation KLCardScanAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [CardIOUtilities preload];
    }
    return self;
}

- (void)showScancontrollerFromViewController:(UIViewController *)contorller
                                withCardView:(KLCreateCardView *)view
{
    self.controller = contorller;
    self.cardView = view;
    if (self.controller) {
        if ([CardIOUtilities canReadCardWithCamera]) {
            CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
            scanViewController.suppressScanConfirmation = YES;
            scanViewController.hideCardIOLogo = YES;
            scanViewController.disableManualEntryButtons = YES;
            scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.controller presentViewController:scanViewController animated:YES completion:nil];
        } else {
            //TODO show something
        }
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info
             inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"Scan succeeded with info: %@", info);
    if (self.cardView) {
        [self.cardView setCardNumber:info.cardNumber];
    }
    if (self.controller) {
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User cancelled scan");
    if (self.controller) {
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
