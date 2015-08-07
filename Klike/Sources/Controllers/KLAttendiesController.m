//
//  KLAttendiesController.m
//  Klike
//
//  Created by Alexey on 7/24/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAttendiesController.h"
#import "KLAttendiesList.h"
#import "KLInvitedListConstoller.h"

@interface KLAttendiesController () <KLAttendiesListDelegate, KLInvitedListConstollerDelegate>

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLAttendiesController

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.event = event;
        KLAttendiesList *attendies = [[KLAttendiesList alloc] initWithEvent:event];
        attendies.delegate = self;
        KLInvitedListConstoller *invited = [[KLInvitedListConstoller alloc] initWithEvent:event];
        invited.delegate = self;
        self.childControllers = @[attendies, invited];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.currentNavigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self kl_setTitle:SFLocalized(@"event_attendies")
            withColor:[UIColor blackColor]
              spacing:nil];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KLAttendiesListDelegate methods

- (void)attendiesList:(KLAttendiesList *)attendiesList
      openUserProfile:(KLUserWrapper *)user
{
    [self showUserProfile:user];
}

#pragma mark - KLInvitedListConstollerDelegate methods

- (void)invitedList:(KLInvitedListConstoller *)invitedList
    openUserProfile:(KLUserWrapper *)user
{
    [self showUserProfile:user];
}

@end
