//
//  SFPlaceholderView.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 15/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

/*
Abstract:
Various placeholder views.
*/
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SFPlaceholderState) {
    SFPlaceholderStateNoContent,
    SFPlaceholderStateError,
    SFPlaceholderStateLoading,
};

@interface SFPlaceholderStateInfo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) dispatch_block_t buttonAction;
@end

@protocol ISFPlaceholderCell <NSObject>

@property (nonatomic, readonly) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, readonly) UIImageView *placeholderImage;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) UIButton *actionButton;
@property (nonatomic, readonly) dispatch_block_t actionBlock;
@property (nonatomic, assign) CGFloat preferedHeight;

- (instancetype)initWithTitle:(NSString *)title
                       message:(NSString *)message
                         image:(UIImage *)image
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(dispatch_block_t)buttonAction;
- (void)addErrorTitle:(NSString *)title
              message:(NSString *)message
                image:(UIImage *)image
          buttonTitle:(NSString *)buttonTitle
         buttonAction:(dispatch_block_t)buttonAction;
- (void)setPlaceholderState:(SFPlaceholderState)state animated:(BOOL)animated;

@end

@interface SFPlaceholderCell : UITableViewCell <ISFPlaceholderCell>
@property (nonatomic, strong) NSLayoutConstraint *containterBottonPin;
@property (nonatomic, readonly) UIView *containerView;

+ (SFPlaceholderCell *)emptyPlaceholder;

- (void)updateViewHierarchyWithTitle:(NSString *)title
                             message:(NSString *)message
                               image:(UIImage *)image
                         buttonTitle:(NSString *)buttonTitle
                        buttonAction:(dispatch_block_t)buttonAction;

- (SFPlaceholderStateInfo *)placeholderStateInfoForState:(SFPlaceholderState)state;

@end

@protocol ISFLoadingNextCell <NSObject>
@property (nonatomic, readonly) UIActivityIndicatorView *indicator;
@property (nonatomic, readonly) UIButton *retryButton;
@property (nonatomic, assign) CGFloat preferedHeight;

- (void)showLoadingIndicator:(BOOL)show;
- (void)showRertyButton:(BOOL)show;

@end

@interface SFLoadingNextCell : UITableViewCell <ISFLoadingNextCell>
@end


@protocol ISFCommentsLoadingCell <ISFLoadingNextCell>
@property (nonatomic, readonly) UILabel *countLabel;
- (void)showCountLabel:(BOOL)show;
- (void)updateTitleWithCommentsCount:(NSInteger)commentCount;
@end

@interface SFCommentsLoadingCell : SFLoadingNextCell <ISFCommentsLoadingCell>
@end
