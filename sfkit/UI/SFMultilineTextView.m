//
//  SFMultilineTextView.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 10/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFMultilineTextView.h"
#import "SFExtensions.h"

@implementation SFMultilineTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)dealloc
{
    [self sf_removeAllObservers];
    [self unsubscribeFromAllNotifications];
}

- (void)defaultInit
{
    self.textContainer.widthTracksTextView = YES;
    _numberOfLines = NSIntegerMax;
    
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:17.0];
    }
    if (!self.textColor) {
        self.textColor = [UIColor blackColor];
    }
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UITextViewTextDidChangeNotification withBlock:^(NSNotification *notification) {
        if (notification.object == weakSelf) {
            CGFloat lineHeight = self.font.lineHeight;
            NSInteger lines = weakSelf.contentSize.height / lineHeight;
            if (lines <= weakSelf.numberOfLines) {
                [weakSelf invalidateIntrinsicContentSize];
                if (weakSelf.alignTextVerticaly) {
                    CGFloat topoffset = (weakSelf.bounds.size.height - weakSelf.contentSize.height * weakSelf.zoomScale)/2.0;
                    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
                    weakSelf.contentOffset = CGPointMake(0, - topoffset);
                }
            }
        }
    }];
    [self sf_addObserverForKeyPath:sf_key(contentOffset) withBlock:^(id obj, NSDictionary *change, id observer) {
        CGFloat lineHeight = self.font.lineHeight;
        NSInteger lines = weakSelf.contentSize.height / lineHeight;
        if (lines <= weakSelf.numberOfLines) {
            if (!weakSelf.alignTextVerticaly && !CGPointEqualToPoint(CGPointZero, weakSelf.contentOffset)) {
                weakSelf.contentOffset = CGPointZero;
            }
        }
    }];
}


#pragma mark - Auto Layout
/** Calculates the content size of the text view used by auto layout to adjust the constraints */
- (CGSize)intrinsicContentSize
{
    CGSize newContentSize;
    if ([self.attributedText length] == 0) {
        newContentSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
        if ([self.placeholder notEmpty]) {
            [self showPlaceholder];
        }
    }
    else {
        [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
        newContentSize = [self.layoutManager usedRectForTextContainer:self.textContainer].size;
        [self removePlaceholder];
    }
    return CGSizeMake(UIViewNoIntrinsicMetric, newContentSize.height);
}

- (void)setText:(NSString *)text
{
    //UITextView reset textAlignment after setting text, unlike UITextField
    NSTextAlignment aligment = self.textAlignment;
    if (!text) {
        self.attributedText = nil;
        [self invalidateIntrinsicContentSize];
        return;
    }
    UIFont *font = self.font;
    UIColor *color = self.textColor;
    if (!font) {
        font = [UIFont systemFontOfSize:17.0];
    }
    if (!color) {
        color = [UIColor blackColor];
    }
    NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.alignment = aligment;
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : style };
    self.typingAttributes = attributes;
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [self invalidateIntrinsicContentSize];
}


#pragma mark - Placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self invalidateIntrinsicContentSize];
}

/** Adds the placeholder label as a subview */
- (void)showPlaceholder
{
    if (self.placeholderLabel) {
        [self.placeholderLabel removeFromSuperview];
    }
    self.placeholderLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholderLabel];
    NSMutableDictionary *placeholderAttribs = [NSMutableDictionary dictionary];
    [placeholderAttribs sf_setObject:self.font forKey:NSFontAttributeName];
    [placeholderAttribs sf_setObject:[self.textColor colorWithAlphaComponent:.3] forKey:NSForegroundColorAttributeName];
    [placeholderAttribs addEntriesFromDictionary:self.placeholderAttributes];
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                      attributes:placeholderAttribs];
    self.placeholderLabel.attributedText = placeholder;
    [self.placeholderLabel sizeToFit];
    CGRect caretRect = [self caretRectForPosition:[self beginningOfDocument]];
    self.placeholderLabel.x = caretRect.size.width;
    if (self.alignTextVerticaly) {
        self.placeholderLabel.center = CGPointMake(0, CGRectGetMidY(self.frame));
    }
    if (self.textAlignment == NSTextAlignmentCenter) {
        self.placeholderLabel.centerX = self.middleX;
    }
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleBottomMargin;
    if (_alignTextVerticaly) {
        mask |= UIViewAutoresizingFlexibleTopMargin;
    }
    if (self.textAlignment == NSTextAlignmentCenter) {
        mask |= UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    self.placeholderLabel.autoresizingMask = mask;
}

/** Removes the placeholder label subview */
- (void)removePlaceholder
{
    [self.placeholderLabel removeFromSuperview];
}


@end
