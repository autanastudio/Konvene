//
//  KLParalaxHeaderViewController.m
//  Klike
//
//  Created by admin on 23/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLParalaxHeaderViewController.h"

@interface KLParalaxHeaderViewController ()

@property (nonatomic, strong) UIView *navigationBarAnimationBG;

@end

@implementation KLParalaxHeaderViewController

- (void)dealloc
{
    self.tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)updateHeaderMertics
{
    [self.header layoutIfNeeded];
    CGSize headerSize = [self.header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    UIView *header = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    header.viewSize = headerSize;
    self.tableView.tableHeaderView = header;
    UIView *flexibleVew = [self.header flexibleView];
    [flexibleVew autoPinEdge:ALEdgeTop
                      toEdge:ALEdgeTop
                      ofView:self.view
                  withOffset:0
                    relation:NSLayoutRelationLessThanOrEqual];
}

- (UIView<KLParalaxView> *)buildHeader
{
    return nil;
}

- (void)updateInfo
{
    [self updateHeaderMertics];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.blackNavBar) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat alpha = (scrollView.contentOffset.y + scrollView.contentInset.top - self.tableView.tableHeaderView.height + 64) / 64;
        [self updateNavigationBarWithAlpha:MIN(alpha, 1.)];
    }
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    self.navigationBarAnimationBG.alpha = alpha;
    BOOL newNavBarStyle;
    if (alpha>0.5) {
        newNavBarStyle = YES;
    } else {
        newNavBarStyle = NO;
    }
    if (newNavBarStyle!=self.blackNavBar) {
        self.blackNavBar = newNavBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)layout
{
    self.header = [self buildHeader];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    [header addSubview:self.header];
    self.tableView.tableHeaderView = header;
    [UIView autoSetIdentifier:@"Headers Pins to superview" forConstraints:^{
        [self.header autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.header autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.header autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.header autoSetDimension:ALDimensionWidth toSize:self.view.width];
    }];
    self.navigationBarAnimationBG = [[UIView alloc] initForAutoLayout];
    [self.view addSubview:self.navigationBarAnimationBG];
    self.navBarTitle = [[UILabel alloc] initForAutoLayout];
    [self.view addSubview:self.navBarTitle];
    self.navBarTitle.font = [UIFont helveticaNeue:SFFontStyleMedium size:16.0];
    self.navBarTitle.textColor = [UIColor whiteColor];
    [self.navBarTitle autoAlignAxis:ALAxisHorizontal
                   toSameAxisOfView:self.navigationBarAnimationBG
                         withOffset:10];
    [self.navBarTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.navigationBarAnimationBG autoSetDimension:ALDimensionHeight
                                             toSize:64];
    [self.navigationBarAnimationBG autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                            excludingEdge:ALEdgeBottom];
    [self.navigationBarAnimationBG setBackgroundColor:[UIColor whiteColor]];
    
    UIView *navBarShadow = [[UIView alloc] init];
    navBarShadow.backgroundColor = [UIColor colorFromHex:0xe8e8ed];
    [self.navigationBarAnimationBG addSubview:navBarShadow];
    [navBarShadow autoSetDimension:ALDimensionHeight
                            toSize:0.5];
    [navBarShadow autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                           excludingEdge:ALEdgeTop];
    
    self.navigationBarAnimationBG.alpha = 0;
    [self updateInfo];
}

@end
