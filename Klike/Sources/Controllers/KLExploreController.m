//
//  KLExploreController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreController.h"
#import "KLExploreEventListController.h"
#import "KLExplorePeopleListController.h"

@interface KLExploreController ()

@end

@implementation KLExploreController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        KLExploreEventListController *events = [[KLExploreEventListController alloc] init];
        KLExplorePeopleListController *people = [[KLExplorePeopleListController alloc] init];
        self.childControllers = @[events, people];
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
