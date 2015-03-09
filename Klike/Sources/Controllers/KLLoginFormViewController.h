//
//  KLLoginFormViewController.h
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLLoginFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSubmitButtonPin;

- (IBAction)onSubmit:(id)sender;

@end
