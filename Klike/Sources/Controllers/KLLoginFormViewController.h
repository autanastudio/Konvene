//
//  KLLoginFormViewController.h
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLLoginFormViewController : UIViewController

@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) NSLayoutConstraint *bottomSubmitButtonPin;

- (IBAction)onSubmit:(id)sender;
- (void)addSubmitButtonWithTitle:(NSString *)title;

@end
