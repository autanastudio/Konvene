//
//  KLVenmoInfo.m
//  Klike
//
//  Created by Nick O'Neill on 9/21/15.
//  Copyright © 2015 SFÇD, LLC. All rights reserved.
//

#import "KLVenmoInfo.h"

static NSString *klVenmoInfoClassName = @"UserVenmo";

@implementation KLVenmoInfo

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klVenmoInfoClassName;
}

+ (KLVenmoInfo *)venmoInfoWithoutDataWithId:(NSString *)objectId
{
    return [KLVenmoInfo objectWithoutDataWithClassName:klVenmoInfoClassName
                                          objectId:objectId];
}

@end
