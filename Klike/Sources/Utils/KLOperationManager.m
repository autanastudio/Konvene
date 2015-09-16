//
//  KLOperationManager.m
//  Klike
//
//  Created by Alexey on 9/16/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLOperationManager.h"

@interface KLOperationManager ()

@property (nonatomic, strong) NSOperationQueue *followQueue;

@end

@implementation KLOperationManager

+ (KLOperationManager *)sharedManager
{
    static KLOperationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)addFollowOperationToQueue:(NSBlockOperation *)operation
{
    if (!self.followQueue) {
        self.followQueue = [[NSOperationQueue alloc] init];
        self.followQueue.maxConcurrentOperationCount = 1;
    }
    [self.followQueue addOperation:operation];
}

@end
