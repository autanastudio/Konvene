//
//  KLLoginFormViewController.h
//  Klike
//
//  Created by admin on 08/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^klSubmitionCompletiotion)(NSError *error);

@interface KLLoginFormViewController : UIViewController

//Common views
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *submitLoadingView;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSubmitButtonPin;

@property (nonatomic, assign) BOOL isNavigationBarErrorShown;

@property (nonatomic, weak) id<KLChildrenViewControllerDelegate> kl_parentViewController;

@property (nonatomic, assign) CGFloat keyboardFrameHeight;

- (IBAction)onSubmit:(id)sender;
- (void)dissmissViewController;

- (void)animateFormApearenceWithKeyaboardHeight:(CGFloat)height
                                       duration:(NSTimeInterval)duration;

- (void)showNavbarwithErrorMessage:(NSString *)errorMessage;
- (void)disableControls;
- (void)enableControls;

@end
