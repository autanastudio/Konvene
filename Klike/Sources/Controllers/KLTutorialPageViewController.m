//
//  KLTutorialPageViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTutorialPageViewController.h"

@interface KLTutorialPageViewController ()
@property (strong, nonatomic) UIImageView *tutorialImage;
@property (weak, nonatomic) IBOutlet UILabel *tutorialTitle;
@property (weak, nonatomic) IBOutlet UILabel *tutorialText;

@property (nonatomic, strong) NSArray *animationImages;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) CGFloat animationInset;
@end

@implementation KLTutorialPageViewController

+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages
                                                animationDuration:(NSTimeInterval)duration
                                             topInsetForanimation:(CGFloat)inset
{
    KLTutorialPageViewController *pageController = [[KLTutorialPageViewController alloc] initWithTitle:title
                                                                                                  text:text
                                                                                       animationImages:animationImages
                                                                                     animationDuration:duration
                                                                                  topInsetForanimation:inset];
    [pageController view];
    return pageController;
}

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages
            animationDuration:(NSTimeInterval)duration
         topInsetForanimation:(CGFloat)inset
{
    if (self = [super init]) {
        self.titleString = title;
        self.textString = text;
        self.animationImages = animationImages;
        self.animationDuration = duration;
        self.animationInset = inset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tutorialTitle.text = self.titleString;
    self.tutorialText.text = self.textString;
    
    UIImage *tempImage = self.animationImages[0];
    self.tutorialImage = [[UIImageView alloc] initWithImage:tempImage];
    [self.tutorialImage autoSetDimensionsToSize:tempImage.size];
    [self.view addSubview:self.tutorialImage];
    [self.tutorialImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.tutorialImage autoPinEdgeToSuperviewEdge:ALEdgeTop
                                         withInset:self.animationInset];
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

- (NSArray *)prepareImagesforAnimationWithName:(NSString *)name
                                          count:(NSNumber *)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[count integerValue]; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%05d", name, i];
        [array addObject:[UIImage imageNamed:imageName]];
    }
    return array;
}

@end
