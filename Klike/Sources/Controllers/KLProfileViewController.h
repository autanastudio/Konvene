//
//  KLProfileViewController.h
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLParalaxHeaderViewController.h"

@interface KLProfileViewController : KLParalaxHeaderViewController

@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) KLUserWrapper *user;

- (instancetype)initWithUser:(KLUserWrapper *)user;

@end
