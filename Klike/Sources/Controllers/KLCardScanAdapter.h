//
//  KLCardScanAdapter.h
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CardIO/CardIO.h>

@class KLCreateCardView;

@interface KLCardScanAdapter : NSObject <CardIOPaymentViewControllerDelegate>

- (void)showScancontrollerFromViewController:(UIViewController *)contorller
                                withCardView:(KLCreateCardView *)view;

@end
