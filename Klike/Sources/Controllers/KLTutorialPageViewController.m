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
@end

@implementation KLTutorialPageViewController

+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages
{
    KLTutorialPageViewController *pageController = [[KLTutorialPageViewController alloc] initWithTitle:title
                                                                                                  text:text
                                                                                       animationImages:animationImages];
    [pageController view];
    return pageController;
}

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages
{
    if (self = [super init]) {
        self.titleString = title;
        self.textString = text;
        self.animationImages = animationImages;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tutorialTitle.text = self.titleString;
    self.tutorialText.text = self.textString;
    //TODO real animtion
//    self.tutorialImage.animationImages = self.animationImages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
