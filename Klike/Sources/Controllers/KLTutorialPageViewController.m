//
//  KLTutorialPageViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTutorialPageViewController.h"

@interface KLTutorialPageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage;
@property (weak, nonatomic) IBOutlet UILabel *tutorialTitle;
@property (weak, nonatomic) IBOutlet UILabel *tutorialText;

@property (nonatomic, strong) NSArray *animationImages;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@end

@implementation KLTutorialPageViewController

+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages
                                                animationDuration:(NSTimeInterval)duration
{
    KLTutorialPageViewController *pageController = [[KLTutorialPageViewController alloc] initWithTitle:title
                                                                                                  text:text
                                                                                       animationImages:animationImages
                                                                                     animationDuration:duration];
    [pageController view];
    return pageController;
}

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages
            animationDuration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        self.titleString = title;
        self.textString = text;
        self.animationImages = animationImages;
        self.animationDuration = duration;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tutorialTitle.text = self.titleString;
    self.tutorialText.text = self.textString;
    self.tutorialImage.animationImages = self.animationImages;
    self.tutorialImage.animationDuration = self.animationDuration;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tutorialImage startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tutorialImage stopAnimating];
}

@end
