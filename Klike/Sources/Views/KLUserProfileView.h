//
//  KLUserProfileView.h
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserView.h"

@interface KLUserProfileView : KLUserView

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, assign) BOOL isFollowed;

- (void)updateFollowStatus;

@end
