//
//  KLEventFooterView.h
//  Klike
//
//  Created by admin on 29/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLParalaxHeaderViewController.h"
#import "SFTextField.h"

@class KLEventFooterView;

@protocol KLEventFooterDelegate <NSObject>

- (void)eventFooter:(KLEventFooterView *)view
        showProfile:(KLUserWrapper *)userWrapper;

@end

@interface KLEventFooterView : UIView <KLParalaxView>

@property (nonatomic, assign) CGFloat fullHeight;
@property (weak, nonatomic) IBOutlet KLTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *flexibleView;
@property (weak, nonatomic) IBOutlet UILabel *commentsTitle;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *hideCommentButton;
@property (weak, nonatomic) IBOutlet SFTextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) id<KLEventFooterDelegate> delegate;

- (void)configureWithEvent:(KLEvent *)event;

@end
