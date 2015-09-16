//
//  KLOperationManager.h
//  Klike
//
//  Created by Alexey on 9/16/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLOperationManager : NSObject

+ (KLOperationManager *)sharedManager;

- (void)addFollowOperationToQueue:(NSBlockOperation *)operation;

@end
