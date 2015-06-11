//
//  KLExplorePeopleListController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleListController.h"
#import "KLExplorePeopleDataSource.h"
#import "KLActivityIndicator.h"
#import "KLExplorePeopleSearchDataSource.h"
#import <APAddressBook/APAddressBook.h>
#import <APAddressBook/APContact.h>
#import "KLInviteFriendTableViewCell.h"
#import "NBPhoneNumberUtil.h"

static CGFloat klExplorePeopleCellHeight = 64.;

@interface KLExplorePeopleListController () <UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) KLExplorePeopleSearchDataSource *searchDataSource;
@property (nonatomic, assign) KLExplorePeopleListState state;
@property (nonatomic, strong) NSString *searchString;

@property APAddressBook *addressBook;

@end

@implementation KLExplorePeopleListController

- (instancetype)init
{
    if (self = [super init]) {
        self.state = KLExplorePeopleListStateDefault;
        self.searchString = @"";
    }
    return self;
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (SFDataSource *)buildDataSource
{
    KLExplorePeopleDataSource *dataSource = [[KLExplorePeopleDataSource alloc] init];
    return dataSource;
}

- (NSString *)title
{
    return SFLocalized(@"explore.people.title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klExplorePeopleCellHeight;
    
    self.searchDataSource = [[KLExplorePeopleSearchDataSource alloc] init];
    self.searchDataSource.delegate = self.dataSource.delegate;
    [self.searchDataSource registerReusableViewsWithTableView:self.tableView];
    self.searchBar = [[UISearchBar alloc] initWithFrame:YSRectMakeFromSize(self.tableView.width, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"Search";
    
    self.addressBook = [[APAddressBook alloc] init];
    if ([APAddressBook access] == APAddressBookAccessGranted) {
        [self loadContactList];
    }
    
    [self updateHeader];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
}

- (void)updateHeader
{
    if ([APAddressBook access] == APAddressBookAccessUnknown) {
        UIView *header = [[UIView alloc] initWithFrame:YSRectMakeFromSize(self.tableView.width, 112.)];
        header.backgroundColor = [UIColor clearColor];
        [header addSubview:self.searchBar];
        [self.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                 excludingEdge:ALEdgeBottom];
        [self.searchBar autoSetDimension:ALDimensionHeight toSize:44.];
        UIView *inviteView = [[UIView alloc] init];
        inviteView.backgroundColor = [UIColor whiteColor];
        [header addSubview:inviteView];
        [inviteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 4., 0)
                                             excludingEdge:ALEdgeTop];
        UIButton *connectContacts = [[UIButton alloc] init];
        [inviteView addSubview:connectContacts];
        [connectContacts autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [connectContacts addTarget:self
                            action:@selector(onConnectContacts:)
                  forControlEvents:UIControlEventTouchUpInside];
        UIImageView *contactImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_cont"]];
        [inviteView addSubview:contactImage];
        [contactImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.];
        [contactImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [contactImage setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
        UILabel *contactLabel = [[UILabel alloc] init];
        contactLabel.text = @"Connect Contacts";
        contactLabel.font = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
        contactLabel.textColor = [UIColor colorFromHex:0x6569C7];
        [inviteView addSubview:contactLabel];
        [contactLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [contactLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeRight
                           ofView:contactImage
                       withOffset:16.];
    
        [inviteView autoPinEdge:ALEdgeTop
                         toEdge:ALEdgeBottom
                         ofView:self.searchBar
                     withOffset:0];
        self.tableView.tableHeaderView = header;
    } else {
        UIView *header = [[UIView alloc] initWithFrame:YSRectMakeFromSize(self.tableView.width, 44.)];
        [self.searchBar removeFromSuperview];
        self.tableView.tableHeaderView = nil;
        [header addSubview:self.searchBar];
        [self.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.tableView.tableHeaderView = header;
    }
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
        
    } else {
        [self loadContactList];
    }
}

- (void)loadContactList
{
    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.filterBlock = ^BOOL(APContact *contact) {
        return [contact.compositeName rangeOfString:@"GroupMe"].location==NSNotFound;
    };
    [self.addressBook loadContacts:^(NSArray *contacts, NSError *error) {
         if (!error)
         {
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
             KLExplorePeopleDataSource *dataSource = (KLExplorePeopleDataSource *)weakSelf.dataSource;
             dataSource.phoneNumbers = phones;
             [weakSelf refreshList];
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

- (void)refreshList
{
    [self updateHeader];
    [super refreshList];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFDataSource *currentDataSource = self.searchBar.isFirstResponder ? self.searchDataSource : self.dataSource;
    if ([currentDataSource obscuredByPlaceholder]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(explorePeopleList:openUserProfile:)]) {
        PFUser *userObject = [currentDataSource itemAtIndexPath:indexPath];
        KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
        [self.delegate explorePeopleList:self openUserProfile:userWrapper];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBar.isFirstResponder && self.searchDataSource.obscuredByPlaceholder) {
        return 250.;
    }
    return UITableViewAutomaticDimension;
}

- (void)didReachEndOfList
{
    if (self.searchBar.isFirstResponder) {
        return;
    }
    if (![self.dataSource.loadingState isEqualToString:SFLoadStateErrorNext]) {
        [self.dataSource setNeedLoadNextPage];
    }
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    [self.searchDataSource setNeedLoadSearchContentWithQuery:searchText];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (self.state == KLExplorePeopleListStateDefault) {
        self.state = KLExplorePeopleListStateSearch;
        self.tableView.dataSource = self.searchDataSource;
        [searchBar setShowsCancelButton:YES
                               animated:NO];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.state = KLExplorePeopleListStateDefault;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
    [searchBar setShowsCancelButton:NO
                           animated:NO];
}

@end
