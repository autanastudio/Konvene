//
//  KLParalaxHeaderViewController.h
//  Klike
//
//  Created by admin on 23/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@protocol KLParalaxView <NSObject>
- (UIView *)flexibleView;
@end

@interface KLParalaxHeaderViewController : KLListViewController

@property(nonatomic, strong) UIView<KLParalaxView> *header;
@property (nonatomic, strong) UILabel *navBarTitle;

- (UIView<KLParalaxView> *)buildHeader;
- (void)updateInfo;
- (void)updateNavigationBarWithAlpha:(CGFloat)alpha;
- (void)layout;

@end
