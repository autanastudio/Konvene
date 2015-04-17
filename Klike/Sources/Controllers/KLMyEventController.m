//
//  KLMyEventController.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLMyEventController.h"
#import "KLEventListController.h"
#import "SFPagedDataSource.h"

@interface KLMyEventController ()

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) NSArray *childControllers;

@property (nonatomic, strong) SFPagedDataSource *dataSource;

@end

@implementation KLMyEventController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        KLEventListController *goingEvents = [[KLEventListController alloc] initWithType:KLEVEntListTypeGoing];
        KLEventListController *savedEvents = [[KLEventListController alloc] initWithType:KLEVEntListTypeSaved];
        _childControllers = @[goingEvents, savedEvents];
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
    [self kl_setTitle:SFLocalized(@"event.myevent.title") withColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
}

@end
