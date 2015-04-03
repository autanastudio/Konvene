//
//  KLLoginDetailsViewController.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLoginDetailsViewController.h"
#import "SFTextField.h"
#import "SFAlertMessageView.h"
#import "KLAccountManager.h"
#import "KLUserWrapper.h"
#import "KLLocationSelectTableViewController.h"
#import "KLForsquareVenue.h"
#import "KLInviteFriendsViewController.h"

@interface KLLoginDetailsViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KLLocationSelectTableViewControllerDelegate, KLChildrenViewControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet SFTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;

@property (nonatomic, strong) KLUserWrapper *currentUser;
@property (nonatomic, strong) UIImage *userImage;
@end

static CGFloat klHalfSizeofImage = 32.;
static NSInteger klMaxNameLength = 30;
static NSInteger klMinNameLength = 3;

@implementation KLLoginDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = [KLAccountManager sharedManager].currentUser;
    
    [self kl_setNavigationBarColor:nil];
    
    [self.userImageView.layer setCornerRadius:klHalfSizeofImage];
    [self.userImageView.layer setMasksToBounds:YES];
    [self.userPhotoButton.layer setCornerRadius:klHalfSizeofImage];
    [self.userPhotoButton.layer setMasksToBounds:YES];
    
    self.nameTextField.placeholder = SFLocalized(@"Full Name");
    self.nameTextField.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                               style:SFFontStyleRegular
                                                size:16.];
    self.nameTextField.placeholderColor = [UIColor colorFromHex:0x91919f];
    
    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"DETAILS") withColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)disableControls
{
    [super disableControls];
    self.userPhotoButton.enabled = NO;
    self.locationButton.enabled = NO;
    self.nameTextField.enabled = NO;
}

- (void)enableControls
{
    [super enableControls];
    self.userPhotoButton.enabled = YES;
    self.locationButton.enabled = YES;
    self.nameTextField.enabled = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length>klMaxNameLength) {
        return NO;
    } else if(newText.length<klMinNameLength) {
        self.submitButton.enabled = NO;
    } else {
        self.submitButton.enabled = YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions

- (IBAction)onSubmit:(id)sender
{
    [self disableControls];
    if (self.userImage) {
        [self.currentUser updateUserImage:self.userImage];
    }
    self.currentUser.fullName = self.nameTextField.text;
    self.currentUser.isRegistered = @(YES);
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] uploadUserDataToServer:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            KLInviteFriendsViewController *inviteVC = [[KLInviteFriendsViewController alloc] initForType:KLInviteTypeFriends];
            inviteVC.isAfterSignIn = YES;
            [self.navigationController pushViewController:inviteVC animated:YES];
        } else {
            
        }
        [weakSelf enableControls];
    }];
}

- (IBAction)onUserPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onLocation:(id)sender
{
    KLLocationSelectTableViewController *location = [[KLLocationSelectTableViewController alloc] init];
    location.delegate = self;
    location.kl_parentViewController = self;
    [self.navigationController pushViewController:location
                                         animated:YES];
}

#pragma mark - UiActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = @[(id)kUTTypeImage];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSString *message = @"Camera is unavalible. Choose profile photo from Library.";
                SFAlertMessageView *view = [SFAlertMessageView infoViewWithMessage:message];
                [view show];
            } else {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerControllerCameraDevice cameraDevice = UIImagePickerControllerCameraDeviceRear;
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                    cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                picker.cameraDevice = cameraDevice;
            }
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker
                               animated:YES
                             completion:nil];
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
    }];
    self.userImage = image;
    self.userImageView.image = image;
    [self.userPhotoButton setImage:[UIImage imageNamed:@"ic_cam"] forState:UIControlStateNormal];
    self.userPhotoButton.backgroundColor = [UIColor colorWithWhite:0
                                                             alpha:.6];
}

#pragma mark - KLLocationSelectTableViewControllerDelegate

- (void)dissmissLocationSelectTableView:(KLLocationSelectTableViewController *)selectViewController
                              withVenue:(KLForsquareVenue *)venue
{
    self.currentUser.place = venue;
    [self.locationButton setTitle:venue.name
                         forState:UIControlStateNormal];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - KLChildrenViewControllerDelegate

- (void)viewController:(UIViewController *)viewController dissmissAnimated:(BOOL)animated
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
