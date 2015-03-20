//
//  KLInviteFriendsViewController.m
//  Klike
//
//  Created by Dima on 18.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLInviteFriendsViewController.h"
#import "KLInviteSocialTableViewCell.h"
#import "KLInviteFriendTableViewCell.h"
#import "KLAddressBookHelper.h"

static NSString *inviteButtonCellId = @"inviteButtonCellId";
static NSString *inviteKlikeCellId = @"inviteKlikeCellId";
static NSString *inviteContactCellId = @"inviteContactCellId";

@interface KLInviteFriendsViewController ()
{
    IBOutlet UIButton *_buttonInviteFacebook;
    IBOutlet UIButton *_buttonConnectContacts;
    IBOutlet UIButton *_buttonInviteEmail;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_viewScrollable;
}

@property UITableView *tableView;
@property NSArray *unregisteredUsers;
@property NSArray *registeredUsers;
@end

@implementation KLInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView addSubview:_viewScrollable];
    _scrollView.hidden = YES;
    _tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:_tableView];
    self.tableView = _tableView;
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteSocialTableViewCell" bundle:nil] forCellReuseIdentifier:inviteButtonCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell" bundle:nil] forCellReuseIdentifier:inviteKlikeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell" bundle:nil] forCellReuseIdentifier:inviteContactCellId];
    [self loadContactList];

}

- (void)loadContactList
{
    KLAddressBookHelper *helper = [[KLAddressBookHelper alloc] init];
    void (^ loadContacts)() = ^{
        [helper loadListOfContacts:^(NSArray *rawContants) {
            //TODO sort registered and unregistered users by email
            _unregisteredUsers = rawContants;
            [self.tableView reloadData];
        }];
    };
    if (helper.isAuthorized) {
        loadContacts();
    }
    else {
        [helper authorizeWithCompletionHandler:^(BOOL success) {
            loadContacts();
        }];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case 1:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case 2:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 48)];
    headerView.backgroundColor = [UIColor colorFromHex:0xf2f2f2];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 305, 16)];
    [headerView addSubview:label];
    NSString *sectionName;
    switch (section) {
        case 1:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case 2:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    label.text = sectionName;
    label.textColor = [UIColor colorFromHex:0xa5a4a4];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else {
        if (section == 1) {
            return _registeredUsers.count;
        }
        else
            return _unregisteredUsers.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        KLInviteSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteButtonCellId forIndexPath:indexPath];
        [cell configureForInviteType:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        KLInviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteKlikeCellId forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.registered = YES;
        }
        else {
            cell.registered = NO;
        }
        [cell configureWithUser:[_unregisteredUsers objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

