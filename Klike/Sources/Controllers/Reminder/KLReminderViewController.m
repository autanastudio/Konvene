//
//  KLReminderViewController.m
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLReminderViewController.h"
#import "KLReminderTableViewCell.h"



@interface KLReminderViewController () <UITableViewDataSource, UITableViewDelegate, KLReminderTableViewCellDelegate>

@end

@implementation KLReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_table registerNib:[UINib nibWithNibName:@"KLReminderTableViewCell" bundle:[NSBundle mainBundle] ] forCellReuseIdentifier:@"KLReminderTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                       target:self
                                                     selector:@selector(onBack)];
    backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    [self kl_setTitle:SFLocalized(@"remindersHeader")
            withColor:[UIColor blackColor] spacing:nil];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return KLEventReminderTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLReminderTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"KLReminderTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.type = indexPath.row;
    return cell;
}

#pragma mark - KLReminderTableViewCellDelegate <NSObject>

- (void)reminderTableViewCell:(KLReminderTableViewCell*)cell didChangeState:(BOOL)state
{
    if (state) 
        [[KLEventManager sharedManager] addReminder:cell.type toEvent:self.event];
    else
        [[KLEventManager sharedManager] removeReminder:cell.type toEvent:self.event];
}

- (BOOL)stateForReminderTableViewCell:(KLReminderTableViewCell*)cell
{
    return [[KLEventManager sharedManager] reminder:cell.type forEvent:self.event] != nil;
}

@end
