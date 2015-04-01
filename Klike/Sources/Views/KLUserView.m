//
//  KLUserView.m
//  Klike
//
//  Created by admin on 26/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserView.h"
#import "KLUserWrapper.h"

@implementation KLUserView

- (void)configureWithRootView:(UIView *)rootView
{
    CGFloat viewControllerWidth = rootView.bounds.size.width;
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
    [self autoSetDimension:ALDimensionWidth
                             toSize:viewControllerWidth];
    
    [self.userImageView kl_fromRectToCircle];
    [self.backImageView autoPinEdge:ALEdgeTop
                             toEdge:ALEdgeTop
                             ofView:rootView
                         withOffset:0.
                           relation:NSLayoutRelationLessThanOrEqual];
    NSDictionary *views = @{@"superView" : rootView,
                            @"topImageView" : self.backImageView};
    NSString *format = @"V:[superView]-0@750-[topImageView]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [rootView addConstraints:constraints];
    
    [self.tabelHeaderView autoPinEdge:ALEdgeTop
                               toEdge:ALEdgeTop
                               ofView:rootView
                           withOffset:64.
                             relation:NSLayoutRelationGreaterThanOrEqual];
    
    CGFloat tablePrefferHeight = 0;//rootView.bounds.size.height - self.tabelHeaderView.bounds.size.height - 64.;
    [self.tableView autoSetDimension:ALDimensionHeight
                              toSize:tablePrefferHeight];
}

- (void)updateWithUser:(KLUserWrapper *)user
{
    if (user.userImage) {
        self.userImageView.file = user.userImage;
        [self.userImageView loadInBackground];
    }
    if (user.userBackImage) {
        CAGradientLayer *gradientForBack = [self grayGradient];
        gradientForBack.frame = self.backImageView.frame;
        [self.backImageView.layer addSublayer:gradientForBack];
        self.backImageView.file = user.userBackImage;
        [self.backImageView loadInBackground];
    }
    self.userNameLabel.text = user.fullName;
    [self.userFollowersButton setTitle:[NSString stringWithFormat:@"%d", [user.followers count]]
                              forState:UIControlStateNormal];
    [self.userFolowingButton setTitle:[NSString stringWithFormat:@"%d", [user.following count]]
                             forState:UIControlStateNormal];
}

- (CAGradientLayer *)grayGradient
{
    UIColor *topColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
    UIColor *bottomColor = [UIColor clearColor];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}

@end
