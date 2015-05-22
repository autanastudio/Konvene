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

@property (nonatomic, strong) CAAnimation *eggAnimation;

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
    
    if (!self.animationImages) {
        NSArray *startImages = [UIImageView imagesForAnimationWithnamePattern:@"radar_start_%05d"
                                                                        count:@(40)];
        NSArray *cycleImages = [UIImageView imagesForAnimationWithnamePattern:@"radar_cycle_%05d"
                                                                        count:@(40)];
        NSArray *cycleEggsImages = [UIImageView imagesForAnimationWithnamePattern:@"radar_cycle_eggs%05d"
                                                                            count:@(40)];
        
        UIImage *tempImage = startImages[0];
        self.tutorialImage = [[UIImageView alloc] initWithImage:tempImage];
        [self.tutorialImage autoSetDimensionsToSize:tempImage.size];
        [self.view insertSubview:self.tutorialImage
                         atIndex:0];
        [self.tutorialImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.tutorialImage autoPinEdgeToSuperviewEdge:ALEdgeTop
                                             withInset:self.animationInset];
        self.tutorialImage.animationImages = self.animationImages;
        self.tutorialImage.animationDuration = self.animationDuration;
        
        NSMutableArray *startCGImages = [[NSMutableArray alloc] init];
        NSMutableArray *cycleCGImages = [[NSMutableArray alloc] init];
        NSMutableArray *cycleEggsCGImages = [[NSMutableArray alloc] init];
        NSInteger animationImageCount = 40;
        for (UIImage *image in startImages) {
            [startCGImages addObject:(id)image.CGImage];
        }
        for (UIImage *image in cycleImages) {
            [cycleCGImages addObject:(id)image.CGImage];
        }
        for (UIImage *image in cycleEggsImages) {
            [cycleEggsCGImages addObject:(id)image.CGImage];
        }
        
        CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        startAnimation.calculationMode = kCAAnimationDiscrete;
        startAnimation.duration = animationImageCount / 25.0;
        startAnimation.values = startCGImages;
        startAnimation.repeatCount = 1;
        startAnimation.removedOnCompletion = NO;
        startAnimation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *cycleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        cycleAnimation.calculationMode = kCAAnimationDiscrete;
        cycleAnimation.duration = animationImageCount / 25.0;
        cycleAnimation.values = cycleCGImages;
        cycleAnimation.repeatCount = 5;
        cycleAnimation.removedOnCompletion = NO;
        cycleAnimation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *cycleEggAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        cycleEggAnimation.calculationMode = kCAAnimationDiscrete;
        cycleEggAnimation.duration = animationImageCount / 25.0;
        cycleEggAnimation.beginTime = animationImageCount / 25.0 * 5;
        cycleEggAnimation.values = cycleEggsCGImages;
        cycleEggAnimation.repeatCount = 1;
        cycleEggAnimation.removedOnCompletion = NO;
        cycleEggAnimation.fillMode = kCAFillModeForwards;
        
        CAAnimationGroup *cycleGroup = [CAAnimationGroup animation];
        [cycleGroup setDuration:animationImageCount / 25.0*6];
        cycleGroup.repeatCount = INFINITY;
        cycleGroup.beginTime = animationImageCount / 25.0;
        [cycleGroup setAnimations:[NSArray arrayWithObjects:cycleAnimation, cycleEggAnimation, nil]];
    
        self.eggAnimation = [CAAnimationGroup animation];
        [self.eggAnimation setDuration:animationImageCount/25.0*1000];
        self.eggAnimation.repeatCount = INFINITY;
        [(CAAnimationGroup *)self.eggAnimation setAnimations:[NSArray arrayWithObjects:startAnimation, cycleGroup, nil]];
    } else {
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.animationImages) {
        [self.tutorialImage.layer addAnimation:self.eggAnimation
                                        forKey:nil];
    } else {
        [self.tutorialImage startAnimating];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.animationImages) {
        [self.tutorialImage.layer removeAllAnimations];
    } else {
        [self.tutorialImage stopAnimating];
    }
}

@end
