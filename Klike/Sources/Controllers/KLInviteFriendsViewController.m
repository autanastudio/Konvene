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
#import <APAddressBook/APAddressBook.h>
#import <APAddressBook/APContact.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import "SFFacebookAPI.h"
#import "NBPhoneNumberUtil.h"
#import "KLActivityIndicator.h"



static NSString *inviteButtonCellId = @"inviteButtonCellId";
static NSString *inviteKlikeCellId = @"inviteKlikeCellId";
static NSString *klCheckUsersCloudFunctionName = @"checkUsersFromContacts";
static NSString *klUserPhoneNumbersKey = @"phonesArray";

@interface KLInviteFriendsViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, KLInviteSocialTableViewCellDelegate, KLInviteUserCellDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
{
    IBOutlet UIButton *_buttonInviteFacebook;
    IBOutlet UIButton *_buttonConnectContacts;
    IBOutlet UIButton *_buttonInviteEmail;
    UIView *_scrollView;
    IBOutlet UIView *_viewScrollable;
    UISearchBar *searchBar;
    IBOutlet NSLayoutConstraint *_constraintPlaceholderTopOffset;
    IBOutlet NSLayoutConstraint *_constraintEmailButtonOffset;
    NSLayoutConstraint *_constraintViewBottom;
    NSLayoutConstraint *_constraintViewTop;
}

@property UISearchController *searchController;
@property UITableView *tableView;
@property UITableViewController *searchVC;
@property NSArray *unregisteredUsers;
@property NSArray *registeredUsers;
@property NSArray *searchUnregisteredUsers;
@property NSArray *searchRegisteredUsers;
@property SFFacebookAPI *facebook;
@property APAddressBook *addressBook;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation KLInviteFriendsViewController

- (instancetype) initForType:(KLInviteType)type
{
    self = [super init];
    if (self) {
        self.inviteType = type;
        self.isAfterSignIn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    _extendFirstRow = NO;
    [super viewDidLoad];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    self.addressBook = [[APAddressBook alloc] init];
    _scrollView = [[UIView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                          excludingEdge:ALEdgeTop];
    _constraintScrollX = [_scrollView autoPinToTopLayoutGuideOfViewController:self
                                               withInset:0.];
    [_scrollView addSubview:_viewScrollable];
    [_viewScrollable sendSubviewToBack:_buttonConnectContacts];
    [_viewScrollable autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_viewScrollable autoPinEdgeToSuperviewEdge:ALEdgeRight];
    _constraintViewTop = [_viewScrollable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    _constraintViewBottom = [_viewScrollable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    _tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:_tableView];
    [self.view sendSubviewToBack:_tableView];
    self.tableView = _tableView;
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    _constraintScrollX = [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteSocialTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:inviteButtonCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:inviteKlikeCellId];
    switch (self.inviteType)
    {
        case KLInviteTypeFriends:
            if (self.isAfterSignIn) {
                self.navigationItem.title = SFLocalizedString(@"inviteUsers.findFriendsTitle", nil);
            }
            else {
                self.navigationItem.title = SFLocalizedString(@"inviteUsers.inviteFriends", nil);
            }
            break;
        case KLInviteTypeEvent:
            self.navigationItem.title = SFLocalizedString(@"inviteUsers.inviteFriends", nil);            
        default:
            break;
    }
    
    if (!self.needBackButton)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"event_right_arr_whight"]
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(onDone)];
        doneButton.tintColor = [UIColor colorFromHex:0x6466ca];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    if ([APAddressBook access] == APAddressBookAccessGranted) {
        _tableView.hidden = NO;
        _scrollView.hidden = YES;
        [self loadContactList];
    }
    else {
        _tableView.hidden = YES;
        _scrollView.hidden = NO;
    }
    
    self.searchVC = [[UITableViewController alloc] init];
    [self.searchVC.tableView registerNib:[UINib nibWithNibName:@"KLInviteSocialTableViewCell"
                                                   bundle:nil]
                  forCellReuseIdentifier:inviteButtonCellId];
    [self.searchVC.tableView registerNib:[UINib nibWithNibName:@"KLInviteFriendTableViewCell"
                                                   bundle:nil]
                  forCellReuseIdentifier:inviteKlikeCellId];
    self.searchVC.tableView.dataSource = self;
    self.searchVC.tableView.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
//    self.edgesForExtendedLayout =  UIRectEdgeTop;
//    self.searchVC.edgesForExtendedLayout = UIRectEdgeTop;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor colorFromHex:0x6466ca];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    [self.searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageWithRoundedCornersSize:3.0
                               usingImage:[UIImage imageWithColor:[UIColor colorFromHex:0xf2f2f7]
                                                                            size:CGSizeMake(303, 27)]]
                                                          forState:UIControlStateNormal];
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorFromHex:0x91919f],
                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchController.searchBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15], NSForegroundColorAttributeName:[UIColor colorFromHex:0x1d2027]}];
    self.searchController.searchBar.placeholder = @"Search";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.definesPresentationContext = YES;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem.title = @"";
    self.facebook = [[SFFacebookAPI alloc] init];
    
    _queryFollowers = [[KLAccountManager sharedManager] getFollowingQueryForUser:[KLAccountManager sharedManager].currentUser];
    [_queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        _followers = [NSMutableArray array];
        for (PFUser *user in objects)
        {
            KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:user];
            [_followers addObject:userWrapper];
        }
        [_tableView reloadData];
    }];
    
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.height)];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.needBackButton)
    {
        UIBarButtonItem *backButton = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                           target:self
                                                         selector:@selector(onBack)];
        backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)onBack
{
    if (self.needBackButton)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onDone
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)loadContactList
{
    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.filterBlock = ^BOOL(APContact *contact) {
        return [contact.compositeName rangeOfString:@"GroupMe"].location==NSNotFound;
    };
    [self.addressBook loadContacts:^(NSArray *contacts, NSError *error)
    {
         if (!error)
         {
             [self animateButtonsMovement];
             NSMutableArray *unregisteredAfterCheck = [contacts mutableCopy];
             [unregisteredAfterCheck sortUsingComparator:^NSComparisonResult(APContact* obj1, APContact* obj2) {
                 return [[KLInviteFriendTableViewCell contactName:obj1] compare:[KLInviteFriendTableViewCell contactName:obj2]];
             }];
             
             NSMutableArray *phones = [NSMutableArray array];
             NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
             for (APContact *contact in contacts)
             {
                 for (NSString *phone in contact.phones) {
                     NBPhoneNumber *phoneNumber = [phoneUtil parse:phone
                                                     defaultRegion:@"US"
                                                             error:&error];
                     BOOL isValid = [phoneUtil isValidNumber:phoneNumber];
                     if (isValid)
                     {
                         NSString *formattedNumber = [phoneUtil format:phoneNumber
                                                          numberFormat:NBEPhoneNumberFormatE164
                                                                 error:&error];
                         [phones addObject:formattedNumber];
                     }
                 }
             }
             [PFCloud callFunctionInBackground:klCheckUsersCloudFunctionName
                                withParameters:@{ klUserPhoneNumbersKey : phones }
                                         block:^(id object, NSError *error) {
                                             if (!error)
                                             {
                                                 NSArray *pfUsersArray = object;
                                                 NSMutableArray *wrappedUsersArray = [[NSMutableArray alloc] init];
                                                 for (PFUser *user in pfUsersArray)
                                                 {
                                                     KLUserWrapper *wrappedUser = [[KLUserWrapper alloc] initWithUserObject:user];
                                                     [wrappedUsersArray addObject:wrappedUser];
                                                 }
                                                 weakSelf.registeredUsers = wrappedUsersArray;
                                                 weakSelf.searchRegisteredUsers = wrappedUsersArray;
                                                 for (KLUserWrapper *user in weakSelf.registeredUsers) {
                                                     
                                                     BOOL found = YES;
                                                     while (found)
                                                     {
                                                         found = NO;
                                                         for (APContact *contact in unregisteredAfterCheck)
                                                         {
                                                             for (NSString *phone in contact.phones)
                                                             {
                                                                 NBPhoneNumber *phoneNumber = [phoneUtil parse:phone
                                                                                                 defaultRegion:@"US"
                                                                                                         error:&error];
                                                                 BOOL isValid = [phoneUtil isValidNumber:phoneNumber];
                                                                 if (isValid) {
                                                                     NSString *formattedNumber = [phoneUtil format:phoneNumber
                                                                                                      numberFormat:NBEPhoneNumberFormatE164
                                                                                                             error:&error];
                                                                     if ([formattedNumber isEqualToString:user.phoneNumber]){
                                                                         
                                                                         [unregisteredAfterCheck removeObject:contact];
                                                                         found = YES;
                                                                         break;
                                                                     }
                                                                 }
                                                                 
                                                             }
                                                             if (found) {
                                                                 break;
                                                             }
                                                             
                                                         }
                                                     }
                                                 }
                                                 weakSelf.unregisteredUsers = unregisteredAfterCheck;
                                                 weakSelf.searchUnregisteredUsers = unregisteredAfterCheck;
                                                 [weakSelf.tableView reloadData];
                                                 NSLog(@"Results: %@", object);
                                             }
                                             else {
                                                 NSLog(@"Error: %@", error);
                                             }
                                         }];
             [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                       inSection:0]
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:NO];
             [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.searchController.searchBar.height)];
         }
         else {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
         }
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        if (_registeredUsers != nil &&
            _unregisteredUsers != nil)
            return 4;
        return 1;
    }
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case KLSectionTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLSectionTypeContactInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        case KLSectionTypeFollowersInvite:
            sectionName = SFLocalizedString(@"FOLLOWERS", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == KLSectionTypeSocialInvite) {
        return UITableViewAutomaticDimension;
    }
    else if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
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
    switch (section)
    {
        case KLSectionTypeKlikeInvite:
            sectionName = SFLocalizedString(@"inviteUsers.contactsOnKlikeTitle", nil);
            break;
        case KLSectionTypeContactInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteContactsTitle", nil);
            break;
        case KLSectionTypeFollowersInvite:
            sectionName = SFLocalizedString(@"inviteUsers.inviteFollowersTitle", nil);
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
    if (tableView == self.tableView)
    {
        if (section == KLSectionTypeSocialInvite) {
            if (_registeredUsers != nil &&
                _unregisteredUsers != nil)
                return 2;
            return 3;
        }
        else if (section == KLSectionTypeKlikeInvite) {
            return _registeredUsers.count;
        }
        else if (section == KLSectionTypeContactInvite) {
            return _unregisteredUsers.count;
        }
        else {
            return _followers.count;
        }
        
    }
    else
    {
        if (section == KLSectionTypeSocialInvite) {
            return 0;
        }
        else if (section == KLSectionTypeKlikeInvite) {
            return _searchRegisteredUsers.count;
        }
        else {
            return _searchUnregisteredUsers.count;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == KLSectionTypeSocialInvite)
    {
        if (indexPath.row == KLSocialTypeFacebook)
        {
            if (self.facebook.isAuthorized) {
                [weakSelf inviteFacebook];
            }
            else {
                [self.facebook openSession:^(BOOL authorized, NSError *error) {
                    if (authorized) {
                        [weakSelf inviteFacebook];
                    }
                }];
            }
        }
        else if (indexPath.row == KLSocialTypeEmail) {
            [self inviteEmail:nil];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && _extendFirstRow) {
        return 80;
    }
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        if (indexPath.section == KLSectionTypeSocialInvite)
        {
            if (indexPath.row == 2) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                KLActivityIndicator *indicator = [KLActivityIndicator colorIndicator];
                [cell.contentView addSubview:indicator];
                [indicator autoCenterInSuperview];
                [indicator setAnimating:YES];
                return cell;
            }
            KLInviteSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteButtonCellId forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[KLInviteSocialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteButtonCellId];
            }
            [cell configureForInviteType:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        else
        {
            KLInviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteKlikeCellId forIndexPath:indexPath];
            cell.delegate = self;
            if (cell == nil) {
                cell = [[KLInviteFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteKlikeCellId];
            }
            if (indexPath.section == KLSectionTypeKlikeInvite) {
                cell.registered = YES;
                [cell configureWithUser:[_registeredUsers objectAtIndex:indexPath.row] withType:self.inviteType];
            }
            else if (indexPath.section == KLSectionTypeContactInvite) {
                cell.registered = NO;
                [cell configureWithContact:[_unregisteredUsers objectAtIndex:indexPath.row]];
            }
            else {
                cell.registered = YES;
                [cell configureWithUser:[_followers objectAtIndex:indexPath.row] withType:self.inviteType];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else
    {
        if (indexPath.section == KLSectionTypeSocialInvite)
        {
            KLInviteSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteButtonCellId forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[KLInviteSocialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteButtonCellId];
            }
            [cell configureForInviteType:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        else
        {
            KLInviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteKlikeCellId forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[KLInviteFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteKlikeCellId];
            }
            if (indexPath.section == KLSectionTypeKlikeInvite) {
                cell.registered = YES;
                [cell configureWithUser:[_searchRegisteredUsers objectAtIndex:indexPath.row] withType:self.inviteType];
            }
            else {
                cell.registered = NO;
                 [cell configureWithContact:[_searchUnregisteredUsers objectAtIndex:indexPath.row]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)inviteMessage:(NSArray *)phones
{
    if(![MFMessageComposeViewController canSendText])
    {
        NSString *title = SFLocalizedString(@"error.imessage.unavailable.title", nil);
        NSString *message = SFLocalizedString(@"error.imessage.unavailable.message", nil);
        SFAlertMessageView *alert = [[SFAlertMessageView alloc] initWithTitle:title
                                                                      message:message
                                                                        image:nil
                                                                 cancelButton:@"Ok"];
        [alert show];
        NSLog(@"cant send text");
        return;
    }
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    [messageController setRecipients:phones];
    messageController.messageComposeDelegate = self;
    NSString *message = SFLocalizedString(@"inviteUsers.inviteIMessage", nil);
    if (self.inviteType == KLInviteTypeEvent) {
        KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
        message = [NSString stringWithFormat:@"%@ invited you to %@ Download Konvene to attend this event https://itunes.apple.com/us/app/konvene/id924906681?ls=1&mt=8", user.fullName, self.event.title];
    }
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
                                                      if (error)
                                                      {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          }
                                                          else {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}
     ];
}

- (void)inviteEmail:(NSString *)email
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:SFLocalizedString(@"inviteUsers.inviteEmailSubject", nil)];
    if (email)
    [picker setToRecipients:[NSArray arrayWithObjects:email,nil]];
    NSString *emailBody = SFLocalizedString(@"inviteUsers.inviteEmailMessage", nil);
    if (self.inviteType == KLInviteTypeEvent) {
        KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
        emailBody = [NSString stringWithFormat:@"%@ invited you to %@ Download Konvene to attend this event https://itunes.apple.com/us/app/konvene/id924906681?ls=1&mt=8", user.fullName, self.event.title];
    }
    [picker setMessageBody:emailBody isHTML:NO];
    if([MFMailComposeViewController canSendMail]) {
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - KLInviteSocialTableViewCellDelegate methods 

- (void) cellDidClickInvite:(KLInviteSocialTableViewCell *)cell
{
    if (cell.type == KLSocialInviteTypeFacebook) {
        [self inviteFacebook];
    } else {
        [self inviteEmail:nil];
    }
}
#pragma mark - KLInviteFriendTableViewCellDelegate methods

- (void) cellDidClickAddUser:(KLInviteFriendTableViewCell *)cell
{
    KLUserWrapper *user = cell.user;
    
    [[KLAccountManager sharedManager] follow:![[KLAccountManager sharedManager]isFollowing:user]
                                        user:user
                            withCompletition:^(BOOL succeeded, NSError *error) {
        [cell update];
    }];
}
    
- (void) cellDidClickInviteUser:(KLInviteFriendTableViewCell *)cell
{
    KLUserWrapper *user = cell.user;
    [cell setLoading:YES];
    [[KLEventManager sharedManager] inviteUser:user
                                       toEvent:self.event
                                      isInvite:![[KLEventManager sharedManager] isUserInvited:user
                                                                                      toEvent:self.event]
                                  completition:^(id object, NSError *error) {
                                      
                                      if (cell.user == user) {
                                          [cell setLoading:NO];
                                      }
                                      
                                      if (object) {
                                          self.event = object;
                                      }
        [cell update];
    }];
}

- (void) cellDidClickSendMail:(KLInviteFriendTableViewCell *)cell
{
    [self inviteEmail:cell.contact.emails.firstObject];
}

- (void) cellDidClickSendSms:(KLInviteFriendTableViewCell *)cell
{
    [self inviteMessage:cell.contact.phones];
}

- (KLEvent*) cellEvent
{
    return self.event;
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
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

#pragma mark - UISearch* delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSMutableArray *registeredSearchResults = [[NSMutableArray alloc] init];
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (APContact *contact in _unregisteredUsers)
    {
        NSString *contactName = [self contactName:contact];
        if ([[contactName lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [searchResults addObject:contact];
        }
    }
    self.searchUnregisteredUsers = searchResults;
    for (KLUserWrapper *user in _registeredUsers)
    {
        NSString *contactName = user.fullName;
        if ([[contactName lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [registeredSearchResults addObject:user];
        }
        
    }
    self.searchRegisteredUsers = registeredSearchResults;
    [self.searchVC.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    NSMutableArray *registeredSearchResults = [[NSMutableArray alloc] init];
    NSString *strippedStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (APContact *contact in _unregisteredUsers)
    {
        NSString *contactName = [self contactName:contact];
        if ([[contactName lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [searchResults addObject:contact];
        }
    }
    self.searchUnregisteredUsers = searchResults;
    for (KLUserWrapper *user in _registeredUsers)
    {
        NSString *contactName = user.fullName;
        if ([[contactName lowercaseString] rangeOfString:[strippedStr lowercaseString]].location != NSNotFound) {
            [registeredSearchResults addObject:user];
        }
        
    }
    self.searchRegisteredUsers = registeredSearchResults;
    [self.searchVC.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.height) animated:YES];
            [self.searchController.searchBar resignFirstResponder];
        });
    }

- (IBAction)onConnectFacebook:(id)sender
{
    [self inviteFacebook];
}

- (IBAction)onConnectContacts:(id)sender
{
    if ([APAddressBook access] == APAddressBookAccessDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:SFLocalizedString(@"error.contacts.accessdenied", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

    }
    else {
        [self loadContactList];
    }
}

- (IBAction)onConnectEmail:(id)sender
{
    [self inviteEmail:nil];
}

- (void) animateButtonsMovement
{
    [UIView animateWithDuration:1.0f animations:^
     {
         _constraintViewTop.constant = -_buttonInviteFacebook.frame.size.height;
         _constraintViewBottom.constant = -_buttonInviteFacebook.frame.origin.y-_buttonInviteFacebook.frame.size.height;
         _constraintPlaceholderTopOffset.constant = _buttonInviteFacebook.frame.origin.y;
         _constraintEmailButtonOffset.constant = 0;
         [self.view layoutIfNeeded];
     }
                     completion:^(BOOL finished)
     {
         [_viewScrollable setBackgroundColor:[UIColor colorFromHex:0xf2f2f7]];
         CATransition *animation = [CATransition animation];
         animation.type = kCATransitionFade;
         animation.duration = 0.5;
         [_tableView.layer addAnimation:animation forKey:nil];
         _tableView.hidden = NO;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             _scrollView.hidden = YES;
             [self.view sendSubviewToBack:_scrollView];
         });
         
     }];
}

- (NSString *)contactName:(APContact *)contact
{
    if (contact.compositeName) {
        return contact.compositeName;
    }
    else if (contact.firstName && contact.lastName) {
        return [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    }
    else if (contact.firstName || contact.lastName) {
        return contact.firstName ?: contact.lastName;
    }
    else {
        return @"Untitled contact";
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _extendFirstRow = YES;
    [_tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _extendFirstRow = NO;
    [_tableView reloadData];
}

@end

