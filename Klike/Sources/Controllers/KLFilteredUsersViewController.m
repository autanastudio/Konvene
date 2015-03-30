//
//  KLFilteredUsersViewController.m
//  Klike
//
//  Created by Dima on 24.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFilteredUsersViewController.h"
#import <MessageUI/MessageUI.h>
#import "KLInviteFriendTableViewCell.h"

static NSString *inviteKlikeCellId = @"inviteKlikeCellId";
static NSString *inviteContactCellId = @"inviteContactCellId";

@interface KLFilteredUsersViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, KLInviteUserCellDelegate>
@property UITableView *tableView;
@end

@implementation KLFilteredUsersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:_tableView];
    self.tableView = _tableView;
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell" bundle:nil] forCellReuseIdentifier:inviteKlikeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell" bundle:nil] forCellReuseIdentifier:inviteContactCellId];
    self.definesPresentationContext = YES;
}

- (void) update
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case KLFilterTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLFilterTypeContactInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 48.0;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 48)];
    headerView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    NSString *sectionName;
    switch (section) {
        case KLFilterTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLFilterTypeContactInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    label.text = sectionName;
    label.textColor = [UIColor colorFromHex:0x1d2027];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case KLFilterTypeKlikeInvite:
            return _registeredUsers.count;
            break;
        case KLFilterTypeContactInvite:
            return _unregisteredUsers.count;
            break;
        default:
            return _unregisteredUsers.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLInviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteKlikeCellId forIndexPath:indexPath];
    if (indexPath.section == KLFilterTypeKlikeInvite) {
        cell.registered = YES;
    }
    else {
        cell.registered = NO;
    }
    [cell configureWithContacn:[_unregisteredUsers objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (void)inviteMessage
{
    if(![MFMessageComposeViewController canSendText]) {
        NSString *title = SFLocalizedString(@"error.imessage.unavailable.title", nil);
        NSString *message = SFLocalizedString(@"error.imessage.unavailable.message", nil);
        SFAlertMessageView *alert = [[SFAlertMessageView alloc] initWithTitle:title
                                                                      message:message
                                                                        image:nil
                                                                 cancelButton:@"Ok"];
        [alert show];
        return;
    }
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    NSString *message = SFLocalizedString(@"inviteUsers.inviteIMessage", nil);
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
    
}

- (void)inviteEmail
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:SFLocalizedString(@"inviteUsers.inviteEmailSubject", nil)];
    
    NSString *emailBody = SFLocalizedString(@"inviteUsers.inviteEmailMessage", nil);
    [picker setMessageBody:emailBody isHTML:NO];
    
    if([MFMailComposeViewController canSendMail]) {
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - KLInviteFriendTableViewCellDelegate methods
- (void) cellDidClickAddUser:(KLInviteFriendTableViewCell *)cell
{
    NSLog(@"addUser");
}

- (void)cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell
{
    [self inviteEmail];
}

- (void)cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell
{
    [self inviteMessage];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed: {
            NSString *title = SFLocalizedString(@"error.mail.failed.title", nil);
            NSString *message = SFLocalizedString(@"error.mail.failed.message", nil);
            NSString *ok = SFLocalizedString(@"sfkit.message.ok", nil);
            SFAlertMessageView *alert = [[SFAlertMessageView alloc] initWithTitle:title
                                                                          message:message
                                                                            image:nil
                                                                     cancelButton:ok];
            [alert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
