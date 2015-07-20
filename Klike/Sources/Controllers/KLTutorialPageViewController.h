//
//  KLTutorialPageViewController.h
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayerLayer;

@interface KLPlayerView : UIView

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL bottomAlign;
@property (nonatomic, assign) CGFloat topInset;

@end

@interface KLTutorialPageViewController : UIViewController {
    
    IBOutlet KLPlayerView *_viewForGraphic;
}

@property(nonatomic, assign) NSInteger index;
@property(nonatomic) NSString *videoPath;
@property(nonatomic) CGSize videoSize;
@property(nonatomic) BOOL videoBottomAlign;
@property(nonatomic) CGFloat videoTopInset;

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages
            animationDuration:(NSTimeInterval)duration
         topInsetForanimation:(CGFloat)inset;


+ (KLTutorialPageViewController *)tutorialPageControllerWithVideoPath:(NSString*)videPath
                                                                title:(NSString *)title
                                                                 text:(NSString *)text
                                                                 size:(CGSize)size
                                                             topInset:(CGFloat)topInset
                                                          bottomAlign:(BOOL)align;
+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages
                                                animationDuration:(NSTimeInterval)duration
                                             topInsetForanimation:(CGFloat)inset;

@end
