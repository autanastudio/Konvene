//
//  KLFollowersController.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFollowersController.h"
#import "KLUserListDataSource.h"

@interface KLFollowersDataSource : KLUserListDataSource

@property (nonatomic, assign) KLFollowUserListType type;
@property (nonatomic, strong) KLUserWrapper *user;

@end

@implementation KLFollowersDataSource

- (PFQuery *)buildQuery
{
    PFQuery *query;
    switch (self.type) {
        case KLFollowUserListTypeFollowers:
            query = [[KLAccountManager sharedManager] getFollowersQueryForUser:self.user];
            break;
            
        case KLFollowUserListTypeFollowing:
            query = [[KLAccountManager sharedManager] getFollowingQueryForUser:self.user];
            break;
        default:
            break;
    }
    query.limit = 10;
    return query;
}

@end

@interface KLFollowersController ()

@property (nonatomic, assign) KLFollowUserListType type;
@property (nonatomic, strong) KLUserWrapper *user;

@end

@implementation KLFollowersController

- (instancetype)initWithType:(KLFollowUserListType)type
                        user:(KLUserWrapper *)user
{
    self = [super init];
    if (self) {
        self.type = type;
        self.user = user;
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLFollowersDataSource *dataSource = [[KLFollowersDataSource alloc] init];
    dataSource.user = self.user;
    dataSource.type = self.type;
    return dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.type) {
        case KLFollowUserListTypeFollowers:
            [self kl_setTitle:SFLocalized(@"userlist.followers.title")
                    withColor:[UIColor blackColor]];
            break;
            
        case KLFollowUserListTypeFollowing:
            [self kl_setTitle:SFLocalized(@"userlist.following.title")
                    withColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
}

@end
