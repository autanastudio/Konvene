//
//  KLExplorePeopleListController.h
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLExplorePeopleListController;

@protocol KLExplorePeopleDelegate <NSObject>

- (void)explorePeopleList:(KLExplorePeopleListController *)peopleListControler
          openUserProfile:(KLUserWrapper *)user;
- (void)presentSearchController;

@end

@interface KLExplorePeopleListController : KLListViewController

@property (nonatomic, weak) id<KLExplorePeopleDelegate> delegate;

@end
