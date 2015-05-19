//
//  KLEventExtension.m
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventExtension.h"

static NSString *klEventExtensionClassName = @"EventExtension";

@implementation KLEventExtension

@dynamic photos;
@dynamic comments;
@dynamic voters;
@dynamic raiting;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klEventExtensionClassName;
}

- (NSArray *)photos
{
    if (!self[sf_key(photos)]) {
        return [NSArray array];
    } else {
        return self[sf_key(photos)];
    }
}

- (NSArray *)comments
{
    if (!self[sf_key(comments)]) {
        return [NSArray array];
    } else {
        return self[sf_key(comments)];
    }
}

- (NSArray *)voters
{
    if (!self[sf_key(voters)]) {
        return [NSArray array];
    } else {
        return self[sf_key(voters)];
    }
}

- (CGFloat)getVoteAverage
{
    NSInteger votersCount = self.voters.count;
    if (votersCount) {
        return (self.raiting.floatValue/(CGFloat)votersCount + 3.) / 5.;
    } else {
        return 0;
    }
}

@end
