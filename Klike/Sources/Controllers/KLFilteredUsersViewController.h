//
//  KLFilteredUsersViewController.h
//  Klike
//
//  Created by Dima on 24.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KLFilterType)
{
    KLFilterTypeKlikeInvite,
    KLFilterTypeContactInvite
};

@interface KLFilteredUsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property NSArray *unregisteredUsers;
@property NSArray *registeredUsers;
@property (nonatomic, assign) BOOL displayingSearchResults;

- (void) update;
@end
