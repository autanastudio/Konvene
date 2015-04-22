//
//  KLActivityIndicator.m
//  Klike
//
//  Created by admin on 22/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityIndicator.h"

@interface KLActivityIndicator ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) NSArray *animatingImages;
@end

@implementation KLActivityIndicator

+ (KLActivityIndicator *)whiteIndicator
{
    NSArray *images = [UIImageView imagesForAnimationWithnamePattern:@"spinner_white_%05d"
                                                               count:@80];
    return [[KLActivityIndicator alloc] initWithImages:images];
}

+ (KLActivityIndicator *)colorIndicator
{
    NSArray *images = [UIImageView imagesForAnimationWithnamePattern:@"spinner_%05d"
                                                               count:@80];
    return [[KLActivityIndicator alloc] initWithImages:images];
}

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.imageView];
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.imageView.image = self.animatingImages.firstObject;
        self.animatingImages = images;
    }
    return self;
}

- (void)stepAnimation
{
    if (![self.imageView isAnimating]) {
        NSInteger idx = [self.animatingImages indexOfObject:self.imageView.image];
        if (idx == NSNotFound || idx == self.animatingImages.count - 1) {
            idx = -1;
        }
        UIImage *nextImage = self.animatingImages[idx + 1];
        self.imageView.image = nextImage;
    }
}


- (void)setAnimating:(BOOL)animating
{
    if ([self.imageView isAnimating] != animating) {
        if (animating) {
            self.imageView.image = nil;
            self.imageView.animationImages = self.animatingImages;
            [self.imageView startAnimating];
        } else {
            [self.imageView stopAnimating];
            self.imageView.animationImages = nil;
            self.imageView.image = self.animatingImages.firstObject;
        }
    }
}

- (NSInteger)stepCount
{
    return self.animatingImages.count;
}

- (BOOL)animating
{
    return [self.imageView isAnimating];
}

@end
