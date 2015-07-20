//
//  KLTutorialPageViewController.m
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLTutorialPageViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation KLPlayerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center = self.center;
    center.y += self.topInset/2.;
    if (self.bottomAlign) {
        center.y += (self.frame.size.height-self.playerLayer.frame.size.height)/2.;
    }
    self.playerLayer.position = center;
}

- (void)updateConstraints
{
    [super updateConstraints];
}

@end


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
@property (nonatomic, strong) AVPlayer *videoPLayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end



@implementation KLTutorialPageViewController

+ (KLTutorialPageViewController *)tutorialPageControllerWithVideoPath:(NSString*)videPath
                                                                title:(NSString *)title
                                                                 text:(NSString *)text
                                                                 size:(CGSize)size
                                                             topInset:(CGFloat)topInset
                                                          bottomAlign:(BOOL)align
{
    KLTutorialPageViewController *pageController = [[KLTutorialPageViewController alloc] init];
    pageController.videoPath = videPath;
    pageController.titleString = title;
    pageController.textString = text;
    pageController.videoSize = size;
    pageController.videoBottomAlign = align;
    pageController.videoTopInset = topInset;
    return pageController;
}

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
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIApplicationDidBecomeActiveNotification
                         withBlock:^(NSNotification *notification) {
                             [weakSelf startAnimation];
    }];
    
    UIFont *titleFont = [UIFont helveticaNeue:SFFontStyleLight
                                         size:32.];
    self.tutorialTitle.attributedText = [KLAttributedStringHelper stringWithFont:titleFont
                                                                           color:[UIColor whiteColor]
                                                               minimumLineHeight:nil
                                                                charecterSpacing:@0.3
                                                                          string:self.titleString];
    self.tutorialText.attributedText = [KLAttributedStringHelper stringWithFont:[UIFont helveticaNeue:SFFontStyleLight
                                                                                                  size:16.]
                                                                           color:[UIColor whiteColor]
                                                               minimumLineHeight:@24
                                                                charecterSpacing:@0.3
                                                                          string:self.textString];
    
    if (_videoPath) {
        
        AVAsset *assset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_videoPath]];
        AVPlayerItem *item =[[AVPlayerItem alloc]initWithAsset:assset];
        self.videoPLayer = [[AVPlayer alloc]initWithPlayerItem:item];
        self.playerLayer =[AVPlayerLayer playerLayerWithPlayer:self.videoPLayer];
        self.playerLayer.frame = YSRectSetSize(CGRectZero, _videoSize);
        [_viewForGraphic.layer addSublayer:self.playerLayer];
        _viewForGraphic.playerLayer = self.playerLayer;
        _viewForGraphic.bottomAlign = self.videoBottomAlign;
        _viewForGraphic.topInset = self.videoTopInset;
        self.videoPLayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        __weak typeof(self) weakSelf = self;
        [self subscribeForNotification:AVPlayerItemDidPlayToEndTimeNotification
                             withBlock:^(NSNotification *notification) {
                                 [weakSelf performSelector:@selector(playVideo)
                                                withObject:nil
                                                afterDelay:0.1];
                             }];
    }
    else if (!self.animationImages)
    {
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
    }
    else
    {
            UIImage *tempImage = self.animationImages[0];
            self.tutorialImage = [[UIImageView alloc] initWithImage:tempImage];
            [self.tutorialImage autoSetDimensionsToSize:tempImage.size];
            [self.view insertSubview:self.tutorialImage
                             atIndex:0];
            if (self.animationInset <0) {
                [self.tutorialImage autoPinEdge:ALEdgeBottom
                                         toEdge:ALEdgeTop
                                         ofView:self.tutorialTitle
                                     withOffset:0];
            } else {
                [self.tutorialImage autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                     withInset:self.animationInset];
            }
            [self.tutorialImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
            self.tutorialImage.animationImages = self.animationImages;
            self.tutorialImage.animationDuration = self.animationDuration;
    }
}

- (void)playVideo
{
    [self.videoPLayer seekToTime:kCMTimeZero];
}

- (void)startAnimation
{
    if (!self.animationImages) {
        [self.tutorialImage.layer addAnimation:self.eggAnimation
                                        forKey:nil];
    } else {
        [self.tutorialImage startAnimating];
        
    }
    [self.videoPLayer seekToTime:kCMTimeZero];
    [self.videoPLayer play];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.animationImages) {
        [self.tutorialImage.layer removeAllAnimations];
    } else {
        [self.tutorialImage stopAnimating];
    }
    [self.videoPLayer pause];
}

@end
