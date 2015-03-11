//
//  KLAccountManager.h
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAccountManager : NSObject

@property(nonatomic, strong) PFUser *currentUser;

+ (instancetype)sharedManager;

- (BOOL)isCurrentUserAuthorized;
- (void)logout;

@end
