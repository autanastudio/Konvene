//
//  KLPhotoViewer.m
//  Klike
//
//  Created by admin on 14/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPhotoViewer.h"

@interface KLPhotoViewerAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UISwipeGestureRecognizerDirection dismissDirection;
@end

static NSTimeInterval klDismissAnimationTime = .2;


@implementation KLPhotoViewerAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return klDismissAnimationTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:toVC.view];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [transitionContext.containerView addSubview:fromVC.view];
    CGAffineTransform translationTransform = CGAffineTransformIdentity;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (self.dismissDirection & UISwipeGestureRecognizerDirectionLeft) {
        translationTransform = CGAffineTransformMakeTranslation(-screenSize.width, 0);
    } else if (self.dismissDirection & UISwipeGestureRecognizerDirectionRight) {
        translationTransform = CGAffineTransformMakeTranslation(screenSize.width, 0);
    } else if (self.dismissDirection & UISwipeGestureRecognizerDirectionDown) {
        translationTransform = CGAffineTransformMakeTranslation(0, screenSize.height);
    } else{
        translationTransform = CGAffineTransformMakeTranslation(0, -screenSize.height);
        
    }
    
    [UIView animateWithDuration:klDismissAnimationTime
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState|
                                 UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         fromVC.view.transform = translationTransform;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                     }];
}

@end

@interface KLPhotoViewer () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, assign) UISwipeGestureRecognizerDirection dismissDirection;
@end

@implementation KLPhotoViewer

- (instancetype)initWithImageFile:(PFFile *)imageFile
{
    if (self = [super init]) {
        self.imageFile = imageFile;
        self.dismissDirection = UISwipeGestureRecognizerDirectionUp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoImageView.file = self.imageFile;
    [self.photoImageView loadInBackground];
    
    [self addGestureRecognizerForDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizerForDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizerForDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizerForDirection:UISwipeGestureRecognizerDirectionUp];
}

- (void)addGestureRecognizerForDirection:(UISwipeGestureRecognizerDirection)direction
{
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(swipe:)];
    swipeGR.direction = direction;
    [self.view addGestureRecognizer:swipeGR];
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.dismissDirection = recognizer.direction;
    [self.delegate photoViewerDidDissmiss];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    KLPhotoViewerAnimator *animator = [[KLPhotoViewerAnimator alloc] init];
    animator.dismissDirection = self.dismissDirection;
    return animator;
}

@end
