//
//  KLEventExtension.h
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLEventExtension : PFObject <PFSubclassing>

@property(nonatomic, strong) NSArray *photos;
@property(nonatomic, strong) NSArray *comments;
@property(nonatomic, strong) NSNumber *raiting;
@property(nonatomic, strong) NSArray *voters;

- (CGFloat)getVoteAverage;

@end
