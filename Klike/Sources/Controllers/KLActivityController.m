//
//  KLActivityController.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityController.h"

@interface KLActivityController ()

@end


@implementation KLActivityController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
//        KLExploreEventListController *events = [[KLExploreEventListController alloc] init];
//        events.delegate = self;
//        KLExplorePeopleListController *people = [[KLExplorePeopleListController alloc] init];
//        people.delegate = self;
//        self.childControllers = @[events, people];
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
    [self kl_setTitle:SFLocalized(@"explore.title") withColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
}

@end
