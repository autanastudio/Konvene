//
//  SFActivityIndicator.h
//  Livid
//
//  Created by Yarik Smirnov on 4/3/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFActivityIndicator : UIView
@property(nonatomic, assign) BOOL animating;
@property(nonatomic, readonly) NSInteger stepCount;

- (instancetype)initWithImages:(NSArray *)images;

- (void)stepAnimation;

@end
