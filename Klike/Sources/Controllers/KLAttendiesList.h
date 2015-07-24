//
//  KLAttendiesList.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLAttendiesList;

@protocol KLAttendiesListDelegate <NSObject>

- (void)attendiesList:(KLAttendiesList *)attendiesList
      openUserProfile:(KLUserWrapper *)user;

@end

@interface KLAttendiesList : KLListViewController

@property (nonatomic, weak) id<KLAttendiesListDelegate> delegate;

- (instancetype)initWithEvent:(KLEvent *)event;

@end
