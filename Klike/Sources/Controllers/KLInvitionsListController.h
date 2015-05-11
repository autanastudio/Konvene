//
//  KLInvitionsListController.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLListViewController.h"

@class KLInvitionsListController;

@protocol KLInvitionsListDelegate <NSObject>

- (void)invitionsListOCntroller:(KLInvitionsListController *)controller
               showEventDetails:(KLEvent *)event;

@end

@interface KLInvitionsListController : KLListViewController

@property (nonatomic, strong) id<KLInvitionsListDelegate> delegate;

@end
