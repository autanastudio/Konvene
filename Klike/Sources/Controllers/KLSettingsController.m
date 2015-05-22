//
//  KLSettingsController.m
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSettingsController.h"
#import "KLSettingsHeaderView.h"
#import "SFComposedDataSource.h"
#import "KLFormDataSource.h"
#import "KLBasicFormCell.h"
#import "KLSettingCell.h"
#import "KLLocationSelectTableViewController.h"
#import "SFTextField.h"
#import "KLPushSettingsViewController.h"
#import "KLPrivacyPolicyViewController.h"
#import "KLPaySettingsViewController.h"
#import "KLSettingsRemoveCell.h"
#import "AppDelegate.h"



static NSInteger klMaxNameLength = 30;
static NSInteger klMinNameLength = 3;



@interface KLSettingsController () <KLLocationSelectTableViewControllerDelegate, KLSettingsRemoveViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLSettingsHeaderView *header;
@property (nonatomic, strong) KLSettingsRemoveView *footer;

@property (nonatomic, strong) KLBasicFormCell *nameInput;
@property (nonatomic, strong) KLSettingCell *locationInput;

@property (nonatomic, strong) KLSettingCell *paymentCell;

@property (nonatomic, strong) KLSettingCell *notificationsCell;

@property (nonatomic, strong) KLSettingCell *privacyCell;

@property (nonatomic, assign) BOOL changeUserPhoto;

@end



@implementation KLSettingsController

@dynamic header;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self layout];
    
    [self.header.userPhotoButton addTarget:self
                                    action:@selector(onUserPhoto)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.header.backPhotoButton addTarget:self
                                    action:@selector(onChangeBack)
                          forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    self.footer = [self buildFooter];
    self.footer.delegate = self;
    self.tableView.tableFooterView = self.footer;
}

- (KLSettingsRemoveView *)buildFooter
{
    UINib *nib = [UINib nibWithNibName:@"KLSettingsRemoveCell" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    //Sorry
    self.nameInput.textField.returnKeyType = UIReturnKeyDone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

- (void)updateInfo
{
    [self.header updateWithUser:[KLAccountManager sharedManager].currentUser];
    self.navBarTitle.text = SFLocalized(@"settings.title");
    [super updateInfo];
}

- (SFDataSource *)buildDataSource
{
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    
    SFComposedDataSource *form = [[SFComposedDataSource alloc] init];
    
    KLFormDataSource *profileDetails = [[KLFormDataSource alloc] init];
    self.nameInput = [[KLBasicFormCell alloc] initWithName:@"Name"
                                               placeholder:@"Name"
                                                     image:[UIImage imageNamed:@"ic_man"]];
    self.nameInput.value = currentUser.fullName;
    self.nameInput.minimumHeight = 56.;
    self.nameInput.iconInsets = UIEdgeInsetsMake(18., 15., 0, 0);
    [self.nameInput.textField addTarget:self
                                 action:@selector(onFinishNameEditing)
                       forControlEvents:UIControlEventEditingDidEnd];
    KLLocation *userLocation = [[KLLocation alloc] initWithObject:currentUser.place];
    self.locationInput = [[KLSettingCell alloc] initWithName:@"Location"
                                                       image:[UIImage imageNamed:@"event_pin"]
                                                       title:@"Location"
                                                       value:userLocation];
    self.locationInput.iconInsets = UIEdgeInsetsMake(20., 16., 0, 0);
    self.locationInput.minimumHeight = 56;
    
    [profileDetails addFormInput:self.nameInput];
    [profileDetails addFormInput:self.locationInput];
    
    KLFormDataSource *payment = [[KLFormDataSource alloc] init];
    self.paymentCell = [[KLSettingCell alloc] initWithName:@"Payment"
                                                     image:nil
                                                     title:SFLocalized(@"settings.menu.payment")
                                                     value:@""];
    self.paymentCell.minimumHeight = 56;
    [payment addFormInput:self.paymentCell];
    
    KLFormDataSource *notifications = [[KLFormDataSource alloc] init];
    self.notificationsCell = [[KLSettingCell alloc] initWithName:@"Notifications"
                                                           image:nil
                                                           title:SFLocalized(@"settings.menu.notifications")
                                                           value:@""];
    self.notificationsCell.minimumHeight = 56;
    [notifications addFormInput:self.notificationsCell];
    
    KLFormDataSource *privacy = [[KLFormDataSource alloc] init];
    self.privacyCell = [[KLSettingCell alloc] initWithName:@"Privacy"
                                                     image:nil
                                                     title:SFLocalized(@"settings.menu.privacy")
                                                     value:@""];
    self.privacyCell.minimumHeight = 56;
    [privacy addFormInput:self.privacyCell];
    
    [form addDataSource:profileDetails];
    [form addDataSource:payment];
    [form addDataSource:notifications];
    [form addDataSource:privacy];
    
    
    return form;
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    self.navBarTitle.textColor = [UIColor colorWithWhite:0.
                                                   alpha:alpha];
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.backButton.tintColor = navBarElementsColor;
}

- (UIView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"SettingsHeaderView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

#pragma mark - Actions

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onUserPhoto
{
    self.changeUserPhoto = YES;
    [self showPhotosActionSheet];
}

- (void)onChangeBack
{
    self.changeUserPhoto = NO;
    [self showPhotosActionSheet];
}

- (void)onFinishNameEditing
{
    NSString *newName = self.nameInput.value;
    if (newName.length>klMinNameLength) {
        if (newName.length>klMaxNameLength) {
            newName = [newName substringToIndex:klMaxNameLength-1];
            self.nameInput.value = newName;
        }
        [KLAccountManager sharedManager].currentUser.fullName = newName;
        [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
            //TODO disable all
        }];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.locationInput) {
        KLLocationSelectTableViewController *location = [[KLLocationSelectTableViewController alloc] initWithType:KLLocationSelectTypeParse];
        location.delegate = self;
        [self.navigationController pushViewController:location
                                             animated:YES];
    } else if(cell == self.paymentCell) {
        KLPaySettingsViewController *paySettings = [[KLPaySettingsViewController alloc] init];
        [self.navigationController pushViewController:paySettings
                                             animated:YES];
    }
    if (cell == self.privacyCell) {
        KLPrivacyPolicyViewController *vc = [[KLPrivacyPolicyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (cell == self.notificationsCell) {
        KLPushSettingsViewController *vc = [[KLPushSettingsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - KLLocationSelectTableViewControllerDelegate

- (void)dissmissLocationSelectTableView:(KLLocationSelectTableViewController *)selectViewController
                              withVenue:(KLLocation *)venue
{
    self.locationInput.value = venue;
    [KLAccountManager sharedManager].currentUser.place = venue.locationObject;
    [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
        //TODO disable all
    }];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    if (self.changeUserPhoto) {
        [currentUser updateUserImage:image];
    } else {
        [currentUser updateUserBackImage:image];
    }
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
        [weakSelf updateInfo];
    }];
}

#pragma mark - KLSettingsRemoveViewDelegate <NSObject>

- (void)settingsRemoveViewDidPressLogout
{
    [[KLAccountManager sharedManager] logout];
    [ADI presentLoginUIAnimated:YES];
}

- (void)settingsRemoveViewDidPressDelete
{
    [[KLAccountManager sharedManager] logout];
    [ADI presentLoginUIAnimated:YES];
}

@end
