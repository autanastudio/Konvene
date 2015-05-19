//
//  KLEventRatingPageCell.m
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventRatingPageCell.h"

@implementation KLEventRatingPageCell

- (void)awakeFromNib
{
    
    _constraintViewInactiveExternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewInactiveInternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewInactiveInternalGrayWidth.constant = [UIScreen mainScreen].bounds.size.width;
    
    _constraintViewActiveExternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    _constraintViewActiveInternalWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self.contentView layoutIfNeeded];
    
    [self setRating:0 animated:NO];
}

- (void)setRating:(float)rating animated:(BOOL)animated
{
    float screenW = [UIScreen mainScreen].bounds.size.width;
    float inactiveExternalX = 0;
    float inactiveExternalW = 0;
    float inactiveInternalX = 0;
    
    float activeExternalW = 0;
    
    float bound = (screenW / 5 - 40) / 2 - 1;
    float totalActiveWidth = screenW - bound * 2.0;
    activeExternalW = totalActiveWidth * rating + bound + 2 * rating;
    
    inactiveExternalX = activeExternalW;
    inactiveExternalW = screenW - inactiveExternalX;
    inactiveInternalX = - inactiveExternalX;
    
    
    void (^animationBlock)(void) = ^{
        
        _constraintViewInactiveInternalX.constant = inactiveInternalX;
        _constraintViewInactiveInternalGrayX.constant = inactiveInternalX;
        
        _constraintViewInactiveExternalWidth.constant = inactiveExternalW;
        _constraintViewInactiveExternalX.constant = inactiveExternalX;

        _constraintViewActiveExternalWidth.constant = activeExternalW;

        [self.contentView layoutIfNeeded];
    };
    
    
    if (animated)
    {
        [self.contentView layoutIfNeeded];
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             animationBlock();
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        animationBlock();
    }
    
}



- (void)setSelectedElement:(int)selectedElement
{
    _selectedElement = selectedElement;
    
    float screenW = [UIScreen mainScreen].bounds.size.width;
    _constraintImageSelectedX.constant = screenW/5 * selectedElement;
    _constraintImageSelectedW.constant = screenW/5;
    [self.contentView layoutIfNeeded];
    _imageSelected.hidden = NO;
}

- (void)startSeletedImageAnimation
{
    _imageSelected.image = [UIImage imageNamed:@"rating_tap_anim_00058"];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 20; i++) {
        NSString *imageName = [NSString stringWithFormat:@"rating_tap_anim_000%d", 38 + i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [_imageSelected stopAnimating];
    [_imageSelected setAnimationImages:images];
    _imageSelected.animationDuration = 0.5;
    _imageSelected.animationRepeatCount = 1;
    [_imageSelected startAnimating];
}

- (IBAction)onRate:(UIButton*)sender
{
    [self setSelectedElement:sender.tag];
    
    _viewInactiveGray.hidden = NO;
    _imageSelected.hidden = NO;
    _viewInactiveGray.alpha = 0;
    _imageSelected.alpha = 0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         _viewInactiveColored.alpha = 0;
                         _viewInactiveGray.alpha = 1;
                         _imageSelected.alpha = 1;
                     } completion:^(BOOL finished) {
                         _viewActive.hidden = NO;
                         _viewInactiveColored.hidden = YES;
                         [self startSeletedImageAnimation];
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             [self setRating:0.5 animated:YES];
                         });
                     }];
    
    if ([self.delegate respondsToSelector:@selector(ratingCellDidPressRate:)]) {
        [self.delegate performSelector:@selector(ratingCellDidPressRate:) withObject:[NSNumber numberWithInt:sender.tag]];
    }
}

@end
