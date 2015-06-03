//
//  KLTutorialPageViewController.h
//  Klike
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTutorialPageViewController : UIViewController {
    
    IBOutlet UIView *_viewForGraphic;
}

@property(nonatomic, assign) NSInteger index;
@property(nonatomic) NSString *videoPath;

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
              animationImages:(NSArray *)animationImages
            animationDuration:(NSTimeInterval)duration
         topInsetForanimation:(CGFloat)inset;


+ (KLTutorialPageViewController *)tutorialPageControllerWithVideoPath:(NSString*)videPath
                                                                title:(NSString *)title
                                                                 text:(NSString *)text;
+ (KLTutorialPageViewController *)tutorialPageControllerWithTitle:(NSString *)title
                                                             text:(NSString *)text
                                                  animationImages:(NSArray *)animationImages
                                                animationDuration:(NSTimeInterval)duration
                                             topInsetForanimation:(CGFloat)inset;

@end
