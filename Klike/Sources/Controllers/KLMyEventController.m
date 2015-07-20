//
//  KLMyEventController.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLMyEventController.h"
#import "KLEventListController.h"

@interface KLMyEventController () <KLEventListDelegate>

@end

@implementation KLMyEventController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        KLEventListController *goingEvents = [[KLEventListController alloc] initWithType:KLEventListDataSourceTypeGoing];
        goingEvents.delegate = self;
        KLEventListController *savedEvents = [[KLEventListController alloc] initWithType:KLEventListDataSourceTypeSaved];
        savedEvents.delegate = self;
        self.childControllers = @[goingEvents, savedEvents];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:SFLocalized(@"event.myevent.title")
            withColor:[UIColor blackColor]
              spacing:@0.4
     inset:UIEdgeInsetsMake(-1.5, 0.5, 0, 0)];
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - KLEventListDelegate methods

- (void)eventListOCntroller:(KLEventListController *)controller
           showAttendiesForEvent:(KLEvent *)event
{
    [self showEventAttendies:event];
}

- (void)eventListOCntroller:(KLEventListController *)controller
           showEventDetails:(KLEvent *)event
{
    [self showEventDetails:event];
}

@end
