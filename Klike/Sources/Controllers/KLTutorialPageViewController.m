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
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{ NSParagraphStyleAttributeName : style,
                            NSForegroundColorAttributeName : [UIColor whiteColor],
                            NSFontAttributeName : [UIFont helveticaNeue:SFFontStyleLight size:16.]};
    self.tutorialText.attributedText = [[NSAttributedString alloc] initWithString:self.textString
                                                                       attributes:attr];
    
    UIImage *tempImage = self.animationImages[0];
    self.tutorialImage = [[UIImageView alloc] initWithImage:tempImage];
    [self.tutorialImage autoSetDimensionsToSize:tempImage.size];
    [self.view insertSubview:self.tutorialImage
                     atIndex:0];
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

@end
