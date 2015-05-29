//
//  KLPushSettingsViewController.m
//  Klike
//
//  Created by Anton Katekov on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPushSettingsViewController.h"
#import "KLPushSettingsTableViewCell.h"
#import "KLSettingsManager.h"



@interface KLPushSettingsViewController () <KLPushSettingsTableViewCellDelegate>

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
    [self kl_setTitle:SFLocalized(@"pushesHeader")
            withColor:[UIColor blackColor] spacing:nil];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [KLSettingsManager sharedManager].notificationsTitle.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLPushSettingsTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"KLPushSettingsTableViewCell" forIndexPath:indexPath];
    
    NSString *name = [[KLSettingsManager sharedManager].notificationsTitle objectAtIndex:indexPath.row];
    NSArray *nots = [KLSettingsManager sharedManager].notifications;
    BOOL isEnable = [nots containsObject:[[KLSettingsManager sharedManager].defaultNotifications objectAtIndex:indexPath.row]];
    [cell setName:name enabled:isEnable];
    cell.type = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark - KLPushSettingsTableViewCellDelegate <NSObject>

- (void)pushSettingsTableViewCell:(KLPushSettingsTableViewCell*)cell didChangeState:(BOOL)state
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[KLSettingsManager sharedManager].notifications];
    if (state)
        [array addObject:[NSNumber numberWithInt:cell.type]];
    else
        [array removeObject:[NSNumber numberWithInt:cell.type]];
    
    [KLSettingsManager sharedManager].notifications = array;
}


@end
