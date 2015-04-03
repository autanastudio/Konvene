//
//  KLUsersTableViewController.h
//  Klike
//
//  Created by Дмитрий Александров on 30.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//
#import "PFQueryTableViewController.h"
#import "KLUserWrapper.h"

typedef NS_ENUM(NSInteger, KLUserListType){
    KLUserListTypeBoth,
    KLUserListTypeFollowers,
    KLUserListTypeFollowing
};

@interface KLUsersTableViewController : PFQueryTableViewController

- (instancetype)initWithUser:(KLUserWrapper *)user type:(KLUserListType) type;

@end
