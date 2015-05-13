//
//  KLPushSettingsViewController.m
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPushSettingsViewController.h"
#import "KLPushSettingsTableViewCell.h"



@interface KLPushSettingsViewController ()

@end

@implementation KLPushSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_table registerNib:[UINib nibWithNibName:@"KLPushSettingsTableViewCell" bundle:[NSBundle mainBundle] ] forCellReuseIdentifier:@"KLPushSettingsTableViewCell"];
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
            withColor:[UIColor blackColor]];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KLPushSettingsTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"KLPushSettingsTableViewCell" forIndexPath:indexPath];
//    cell.delegate = self;
//    cell.type = indexPath.row;
    return cell;
}

#pragma mark - KLPushSettingsTableViewCellDelegate <NSObject>

- (void)pushSettingsTableViewCell:(KLPushSettingsTableViewCell*)cell didChangeState:(BOOL)state
{
//    if (state)
//        [[KLEventManager sharedManager] addReminder:cell.type toEvent:self.event];
//    else
//        [[KLEventManager sharedManager] removeReminder:cell.type toEvent:self.event];
}

- (BOOL)stateForPushSettingsTableViewCell:(KLPushSettingsTableViewCell*)cell
{
    return NO;
//    return [[KLEventManager sharedManager] reminder:cell.type forEvent:self.event] != nil;
}

@end
