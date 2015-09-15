/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 Various placeholder views.
 
 */

#import "SFPlaceholderCell.h"
#import <PureLayout/PureLayout.h>
#import "SFExtensions.h"

@implementation SFPlaceholderStateInfo
@end

@interface SFPlaceholderCell ()
@property (nonatomic, strong) UIView *placeholderContainer;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation SFPlaceholderCell {
    UIActivityIndicatorView *_activityIndicatorView;
    UIImageView     *_imageView;
    UILabel         *_titleLabel;
    UILabel         *_messageLabel;
    UIButton        *_actionButton;
    dispatch_block_t _actionBlock;
    UIImageView     *_bottomImageView;
    
    SFPlaceholderStateInfo *_noContent;
    SFPlaceholderStateInfo *_error;
}
@synthesize titleLabel = _titleLabel, messageLabel = _messageLabel,actionButton = _actionButton, actionBlock = _actionBlock;
@synthesize loadingIndicator = _activityIndicatorView, preferedHeight = _preferedHeight, placeholderImage = _imageView;

+ (SFPlaceholderCell *)emptyPlaceholder
{
    return [[self alloc] initWithTitle:nil
                               message:nil
                                 image:nil
                           buttonTitle:nil
                          buttonAction:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(UIImage *)image
                  buttonTitle:(NSString *)buttonTitle
                 buttonAction:(dispatch_block_t)buttonAction
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.backgroundColor = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _preferedHeight = NSNotFound;
        
        self.contentView.bounds = CGRectMake(0, 0, 9999.0, 9999.0);
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f
                                                                       constant:0];
        constraint.priority = 999.0;
        [constraint autoInstall];
        
        self.heightConstraint = [view autoSetDimension:ALDimensionHeight
                                                toSize:44.0
                                              relation:NSLayoutRelationGreaterThanOrEqual];
        
        _noContent = [[SFPlaceholderStateInfo alloc] init];
        _noContent.title = title;
        _noContent.message = message;
        _noContent.image = image;
        _noContent.buttonTitle = buttonTitle;
        _noContent.buttonAction = buttonAction;
        
        [self updateViewHierarchyWithTitle:title
                                   message:message
                                     image:image
                               buttonTitle:buttonTitle
                              buttonAction:buttonAction];
        
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicatorView.color = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_activityIndicatorView];
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self.contentView addConstraints:constraints];
    }
    return self;
}

- (void)updateViewHierarchyWithTitle:(NSString *)title
                             message:(NSString *)message
                               image:(UIImage *)image
                         buttonTitle:(NSString *)buttonTitle
                        buttonAction:(dispatch_block_t)buttonAction
{
    if ([message isEqualToString:self.messageLabel.text] && [title isEqualToString:self.titleLabel.text]) {
        return;
    }
    
    [self.placeholderContainer removeFromSuperview];
    self.placeholderContainer = nil;
    
    self.placeholderContainer = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:self.placeholderContainer];
    [self.placeholderContainer autoCenterInSuperview];
    
    self.placeholderContainer.alpha = 0;
    
    UIView *topView = self.placeholderContainer;
    ALAttribute topAttribute = ALAttributeTop;
    CGFloat offset = 0;
    
    UIColor *textColor = [UIColor colorWithWhite:172/255.0 alpha:1];
    
    if (image) {
        _imageView = [[UIImageView alloc] initForAutoLayout];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.image = image;
        [self.placeholderContainer addSubview:_imageView];
        [_imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        topView = _imageView;
        offset = 20.0;
        topAttribute = ALAttributeBottom;
    } else {
        _imageView = nil;
    }
    if (title) {
        _titleLabel = [[UILabel alloc] initForAutoLayout];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = textColor;
        _titleLabel.text = title;
        _titleLabel.backgroundColor = nil;
        _titleLabel.opaque = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:22.0];
        [self.placeholderContainer addSubview:_titleLabel];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_titleLabel autoConstrainAttribute:ALAttributeTop
                                toAttribute:topAttribute
                                     ofView:topView
                                 withOffset:offset];
        topView = _titleLabel;
        offset = 10.0;
        topAttribute = ALAttributeBaseline;
    } else {
        _titleLabel = nil;
    }
    if (message) {
        _messageLabel = [[UILabel alloc] initForAutoLayout];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = message;
        _messageLabel.backgroundColor = nil;
        _messageLabel.opaque = NO;
        _messageLabel.textColor = textColor;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        [self.placeholderContainer addSubview:_messageLabel];
        [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_messageLabel autoConstrainAttribute:ALAttributeTop
                                  toAttribute:topAttribute
                                       ofView:topView
                                   withOffset:offset];
        topView = _messageLabel;
        offset = 20.0;
        topAttribute = ALAttributeBaseline;
    } else {
        _messageLabel = nil;
    }
    if (buttonTitle){
        
        _actionBlock = buttonAction;
        
        _actionButton = [[UIButton alloc] initForAutoLayout];
        _actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_actionButton setTitleColor:[UIColor colorFromHex:0x8776be] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor colorFromHex:0x8776be alpha:.2] forState:UIControlStateHighlighted];
        [_actionButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"buttonInvite"]
                                 forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"buttonInvite_pressed"]
                                 forState:UIControlStateHighlighted];
        [_actionButton addTarget:self
                          action:@selector(onPlaceholderButton)
                forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        
        
        [self.placeholderContainer addSubview:_actionButton];
        [_actionButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_actionButton autoConstrainAttribute:ALAttributeTop
                                  toAttribute:topAttribute
                                       ofView:topView
                                   withOffset:offset];
        topView = _actionButton;
        offset = 20.0;
        topAttribute = ALAttributeBottom;
    } else {
        _actionButton = nil;
    }
    self.containterBottonPin = [topView autoConstrainAttribute:ALAttributeBottom
                                                   toAttribute:topAttribute
                                                        ofView:self.placeholderContainer
                                                    withOffset:- offset];
}

- (void)addErrorTitle:(NSString *)title
              message:(NSString *)message
                image:(UIImage *)image
          buttonTitle:(NSString *)buttonTitle
         buttonAction:(dispatch_block_t)buttonAction
{
    _error = [[SFPlaceholderStateInfo alloc] init];
    _error.title = title;
    _error.message = message;
    _error.image = image;
    _error.buttonTitle = buttonTitle;
    _error.buttonAction = buttonAction;
}

- (SFPlaceholderStateInfo *)placeholderStateInfoForState:(SFPlaceholderState)state
{
    if (state == SFPlaceholderStateError && _error != nil) {
        return _error;
    }
    return _noContent;
}

- (void)setPlaceholderState:(SFPlaceholderState)state animated:(BOOL)animated
{
    SFPlaceholderStateInfo *info = [self placeholderStateInfoForState:state];
    [self updateViewHierarchyWithTitle:info.title
                               message:info.message
                                 image:info.image
                           buttonTitle:info.buttonTitle
                          buttonAction:info.buttonAction];
    [self.placeholderContainer layoutIfNeeded];
    
    [UIView animateWithDuration:(animated ? .25 : 0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _activityIndicatorView.alpha = (state == SFPlaceholderStateLoading ? 1 : 0);
                         self.placeholderContainer.alpha = (state == SFPlaceholderStateLoading ? 0 : 1);
                     } completion:^(BOOL finished) {
                         if (state == SFPlaceholderStateLoading) {
                             [_activityIndicatorView startAnimating];
                         }
                     }];
}

- (UIView *)containerView
{
    return self.placeholderContainer;
}

- (void)onPlaceholderButton
{
    if (_actionBlock) {
        _actionBlock();
    }
}

- (void)setPreferedHeight:(CGFloat)preferedHeight
{
    if (preferedHeight != NSNotFound && preferedHeight > 0) {
        _preferedHeight = preferedHeight;
        self.heightConstraint.constant = preferedHeight;
        [self.contentView layoutIfNeeded];
    }
}

@end

@implementation SFLoadingNextCell {
    UIActivityIndicatorView *_indicator;
    UIButton *_retryButton;
    NSLayoutConstraint *_heightConstraint;
}
@synthesize retryButton = _retryButton, indicator = _indicator, preferedHeight = _preferedHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _indicator = [[UIActivityIndicatorView alloc] initForAutoLayout];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicator.color = [UIColor lightGrayColor];
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


@implementation SFCommentsLoadingCell {
    UILabel *_countLabel;
}
@synthesize countLabel = _countLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor *textColor = [UIColor colorWithWhite:172/255.0 alpha:1];
        
        _countLabel = [[UILabel alloc] initForAutoLayout];
        _countLabel.numberOfLines = 0;
        _countLabel.textColor = textColor;
        _countLabel.backgroundColor = nil;
        _countLabel.opaque = NO;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_countLabel];
        [_countLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    return self;
}

- (void)updateTitleWithCommentsCount:(NSInteger)commentCount
{
    _countLabel.text = [NSString stringWithFormat:@"View %ld previous comment%@", commentCount, (commentCount > 1 ? @"s" : @"")];
}

- (void)showCountLabel:(BOOL)show
{
    _countLabel.hidden = !show;
}

@end
