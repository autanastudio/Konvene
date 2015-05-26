//
//  KLExploreEventListController.h
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLExploreEventListController;

@protocol KLExploreEventListDelegate <NSObject>

- (void)exploreEventListOCntroller:(KLExploreEventListController *)controller
             showAttendiesForEvent:(KLEvent *)event;
- (void)exploreEventListOCntroller:(KLExploreEventListController *)controller
                  showEventDetails:(KLEvent *)event;

@end

@interface KLExploreEventListController : KLListViewController

@property (nonatomic, weak) id<KLExploreEventListDelegate> delegate;
@property (nonatomic) CGPoint selectedEventOffset;

@end
