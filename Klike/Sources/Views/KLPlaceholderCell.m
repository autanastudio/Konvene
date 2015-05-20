//
//  KLPlaceholderCell.m
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPlaceholderCell.h"

@interface KLPlaceholderCell ()
@property (nonatomic, strong) UIView *placeholderContainer;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation KLPlaceholderCell {
    UIActivityIndicatorView *_activityIndicatorView;
    UIImageView     *_imageView;
    UILabel         *_titleLabel;
    UILabel         *_messageLabel;
    UIButton        *_actionButton;
    dispatch_block_t _actionBlock;
    UIImageView     *_bottomImageView;
    BOOL            _needArrow;
    
    SFPlaceholderStateInfo *_noContent;
    SFPlaceholderStateInfo *_error;
}
@synthesize titleLabel = _titleLabel, messageLabel = _messageLabel,actionButton = _actionButton, actionBlock = _actionBlock;
@synthesize loadingIndicator = _activityIndicatorView, preferedHeight = _preferedHeight, placeholderImage = _imageView;

- (void)updateViewHierarchyWithTitle:(NSString *)title
                             message:(NSString *)message
                               image:(UIImage *)image
                         buttonTitle:(NSString *)buttonTitle
                        buttonAction:(dispatch_block_t)buttonAction
{
    if ([message isEqualToString:self.messageLabel.text] &&
        [title isEqualToString:self.titleLabel.text]) {
        return;
    }
    
    [self.placeholderContainer removeFromSuperview];
    self.placeholderContainer = nil;
    
    self.placeholderContainer = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:self.placeholderContainer];
    [self.placeholderContainer autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.placeholderContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                withInset:0];
    [self.placeholderContainer autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                withInset:0];
    
    self.placeholderContainer.alpha = 0;
    
    UIView *topView = self.placeholderContainer;
    ALAttribute topAttribute = ALAttributeTop;
    CGFloat offset = 0;
    
    UIColor *textColor = [UIColor colorFromHex:0xbabad9];
    
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
        _messageLabel.font = [UIFont helveticaNeue:SFFontStyleRegular size:16.];
        [_messageLabel setText:message
         withMinimumLineHeight:24
                 strikethrough:NO];
        [self.placeholderContainer addSubview:_messageLabel];
        [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16. relation:NSLayoutRelationGreaterThanOrEqual];
        [_messageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16. relation:NSLayoutRelationGreaterThanOrEqual];
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
    if (_needArrow) {
        _bottomImageView = [[UIImageView alloc] initForAutoLayout];
        _bottomImageView.contentMode = UIViewContentModeCenter;
        _bottomImageView.image = [UIImage imageNamed:@"ES_arr"];
        [self.placeholderContainer addSubview:_bottomImageView];
        [_bottomImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [_bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        [_bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        topView = _bottomImageView;
        offset = 10.0;
        topAttribute = ALAttributeBottom;
    }
    self.containterBottonPin = [topView autoConstrainAttribute:ALAttributeBottom
                                                   toAttribute:topAttribute
                                                        ofView:self.placeholderContainer
                                                    withOffset:- offset];
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
