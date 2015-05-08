//
//  KLEventListController.h
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

typedef enum : NSUInteger {
    KLEVEntListTypeGoing,
    KLEVEntListTypeSaved,
} KLEVEntListType;

@class KLEventListController;

@protocol KLEventListDelegate <NSObject>

- (void)eventListOCntroller:(KLEventListController *)controller
      showAttendiesForEvent:(KLEvent *)event;
- (void)eventListOCntroller:(KLEventListController *)controller
           showEventDetails:(KLEvent *)event;

@end

@interface KLEventListController : KLListViewController

@property (nonatomic, weak) id<KLEventListDelegate> delegate;

- (instancetype)initWithType:(KLEVEntListType)type;

@end
