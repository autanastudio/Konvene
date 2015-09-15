//
//  SFTextField.m
//  Livid
//
//  Created by Yarik Smirnov on 04/12/14.
//  Copyright (c) 2014 SFCD, LLC. All rights reserved.
//

#import "SFTextField.h"
#import <objc/runtime.h>

//Fix for autolayout super call bug in iOS 7.1
@interface UITextField (FixUITExtFieldAutolayout)
@end

@implementation UITextField (FixUITExtFieldAutolayout)

+ (void)load
{
    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
    
    method_exchangeImplementations(existing, new);
}

- (void)_autolayout_replacementLayoutSubviews
{
    [super layoutSubviews];
    [self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
    [super layoutSubviews];
}

@end

@interface SFTextField ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation SFTextField

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UITextFieldTextDidChangeNotification
                         withBlock:^(NSNotification *notification) {
                             weakSelf.placeholderLabel.hidden = weakSelf.text.notEmpty;
                         }];
    
    self.placeholderLabel = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.textAlignment = NSTextAlignmentLeft;
}

- (void)dealloc
{
    [self unsubscribeFromAllNotifications];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.placeholderLabel.hidden = text.notEmpty;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self.placeholderLabel removeFromSuperview];
    [self addSubview:self.placeholderLabel];
    switch (textAlignment) {
        case NSTextAlignmentLeft: {
            [self.placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [self.placeholderLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            break;
        }
        case NSTextAlignmentCenter: {
            [self.placeholderLabel autoCenterInSuperview];
            break;
        }
        case NSTextAlignmentRight: {
            [self.placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [self.placeholderLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            break;
        }
        default: {
            [self.placeholderLabel autoAlignAxisToSuperviewAxis:ALAxisBaseline];
            [self.placeholderLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            break;
        }
    }
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect rect = [super caretRectForPosition:position];
    if (!self.text.notEmpty) {
        [self.placeholderLabel layoutIfNeeded];
        rect.origin.x = self.placeholderLabel.x - rect.size.width;
    }
    return rect;
}


@end
