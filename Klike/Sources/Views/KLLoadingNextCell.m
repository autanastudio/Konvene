//
//  KLLoadingNextCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoadingNextCell.h"
#import "KLActivityIndicator.h"

@implementation KLLoadingNextCell {
    UIImageView *_indicator;
    UIButton *_retryButton;
    NSLayoutConstraint *_heightConstraint;
}
@synthesize retryButton = _retryButton, preferedHeight = _preferedHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *images = [UIImageView imagesForAnimationWithnamePattern:@"spinner_%05d"
                                                                   count:@80];
        _indicator = [[UIImageView alloc] init];
        _indicator.animationImages = images;
        
        [self.contentView addSubview:_indicator];
        [_indicator autoCenterInSuperview];
        
        _retryButton = [[UIButton alloc] initForAutoLayout];
        _retryButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_retryButton];
        [_retryButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _heightConstraint = [_retryButton autoSetDimension:ALDimensionHeight toSize:50.0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_retryButton setTitle:@"Retry" forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _retryButton.hidden = YES;
    }
    return self;
}

- (void)removeDefaultIndicator
{
    [self.indicator removeFromSuperview];
    _indicator = nil;
}

- (void)showLoadingIndicator:(BOOL)show
{
    _indicator.hidden = !show;
    if (show) {
        [_indicator startAnimating];
    }
}

- (void)showRertyButton:(BOOL)show
{
    _retryButton.hidden = !show;
}

- (void)setPreferedHeight:(CGFloat)preferedHeight
{
    if (preferedHeight != NSNotFound && preferedHeight > 0) {
        _preferedHeight = preferedHeight;
        _heightConstraint.constant = preferedHeight;
        [self layoutIfNeeded];
    }
}

@end
