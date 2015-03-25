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
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import "KLFilteredUsersViewController.h"
#import "SFFacebookAPI.h"

static NSString *inviteButtonCellId = @"inviteButtonCellId";
static NSString *inviteKlikeCellId = @"inviteKlikeCellId";
static NSString *inviteContactCellId = @"inviteContactCellId";

@interface KLInviteFriendsViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, KLInviteUserCellDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
{
    IBOutlet UIButton *_buttonInviteFacebook;
    IBOutlet UIButton *_buttonConnectContacts;
    IBOutlet UIButton *_buttonInviteEmail;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_viewScrollable;
    UISearchBar *searchBar;
}

@property UISearchController *searchController;
@property UITableView *tableView;
@property NSArray *unregisteredUsers;
@property NSArray *registeredUsers;
@property KLFilteredUsersViewController *searchVC;
@property SFFacebookAPI *facebook;
@end

@implementation KLInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
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
    self.navigationItem.title = SFLocalizedString(@"inviteUsers.findFriendsTitle", nil);
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    [self loadContactList];
    self.searchVC = [[KLFilteredUsersViewController alloc] init];
    
    if (!self.searchVC.displayingSearchResults) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        self.searchVC.edgesForExtendedLayout = UIRectEdgeNone;
        self.searchVC.displayingSearchResults = YES;
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
        self.searchController.searchBar.delegate = self;
        self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.width, 44.0);
        self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.searchController.searchBar.placeholder = @"Search";
        self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.definesPresentationContext = YES;
    }
     self.facebook = [[SFFacebookAPI alloc] init];
}

- (void)onDone
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:^{
    }];
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
        case KLSectionTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLSectionTypeContactInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == KLSectionTypeSocialInvite)
    {
        return UITableViewAutomaticDimension;
    }
    return 48.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 48)];
    headerView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    NSString *sectionName;
    switch (section) {
        case KLSectionTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLSectionTypeContactInvite:
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KLSectionTypeSocialInvite) {
        return 2;
    }
    else {
        if (section == KLSectionTypeKlikeInvite) {
            return _registeredUsers.count;
        }
        else
            return _unregisteredUsers.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == KLSectionTypeSocialInvite) {
        if (indexPath.row == KLSocialTypeFacebook) {
            if (self.facebook.isAuthorized) {
                [self inviteFacebook];
            } else {
                [self.facebook openSession:^(BOOL authorized, NSError *error) {
                    [self inviteFacebook];
                }];
            }
        }
        else {
            [self inviteEmail];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == KLSectionTypeSocialInvite) {
        KLInviteSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteButtonCellId forIndexPath:indexPath];
        [cell configureForInviteType:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        KLInviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteKlikeCellId forIndexPath:indexPath];
        if (indexPath.section == KLSectionTypeKlikeInvite) {
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

- (void)inviteMessage
{
    if(![MFMessageComposeViewController canSendText]) {
        NSString *title = SFLocalizedString(@"error.imessage.unavailable.title", nil);
        NSString *message = SFLocalizedString(@"error.imessage.unavailable.message", nil);
//        SFAlertMessageView *alert = [[SFAlertMessageView alloc] initWithTitle:title
//                                                                      message:message
//                                                                        image:nil
//                                                                 cancelButton:@"Ok"];
//        [alert show];
        NSLog(@"cant send text");
        return;
    }
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    NSString *message = SFLocalizedString(@"inviteUsers.inviteIMessage", nil);
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
    
}

- (void)inviteFacebook
{
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"Join Klike"
                                                    title:@"App Requests"
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}
     ];
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

- (void) cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell
{
    [self inviteEmail];
}

- (void) cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell
{
    [self inviteMessage];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed: {
            NSString *title = SFLocalizedString(@"error.mail.failed.title", nil);
            NSString *message = SFLocalizedString(@"error.mail.failed.message", nil);
            NSString *ok = SFLocalizedString(@"sfkit.message.ok", nil);
//            SFAlertMessageView *alert = [[SFAlertMessageView alloc] initWithTitle:title
//                                                                          message:message
//                                                                            image:nil
//                                                                     cancelButton:ok];
//            [alert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearch* delegates



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (PFUser *user in _unregisteredUsers) {
        if ([[user[@"fullName"] lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [searchResults addObject:user];
        }
    }
    self.searchVC.unregisteredUsers = searchResults;
    [self.searchVC update];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (PFUser *user in _unregisteredUsers) {
        if ([[user[@"fullName"] lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [searchResults addObject:user];
        }
    }
    self.searchVC.unregisteredUsers = searchResults;
    [self.searchVC update];
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}

@end

