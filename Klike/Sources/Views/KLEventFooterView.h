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

@interface KLEventFooterView : UIView <KLParalaxView>

@property (weak, nonatomic) IBOutlet KLTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *flexibleView;
@property (weak, nonatomic) IBOutlet UILabel *commentsTitle;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (weak, nonatomic) IBOutlet SFTextField *commentTextField;

- (void)configureWithEvent:(KLEvent *)event;

@end
