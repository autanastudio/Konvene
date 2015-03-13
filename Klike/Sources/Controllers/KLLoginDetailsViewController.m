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

@interface KLLoginDetailsViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet SFTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;

@property (nonatomic, strong) UIImage *userImage;
@end

static CGFloat klHalfSizeofImage = 32.;
static NSInteger klMaxNameLength = 28;

@implementation KLLoginDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self kl_setNavigationBarColor:nil];
    
    [self.userImageView.layer setCornerRadius:klHalfSizeofImage];
    [self.userImageView.layer setMasksToBounds:YES];
    [self.userPhotoButton.layer setCornerRadius:klHalfSizeofImage];
    [self.userPhotoButton.layer setMasksToBounds:YES];
    
    self.nameTextField.placeholder = SFLocalized(@"Full name");
    self.nameTextField.placeholderColor = [UIColor colorFromHex:0x91919f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self kl_setTitle:SFLocalized(@"DETAILS")];
    [self kl_setNavigationBarTitleColor:[UIColor blackColor]];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length>klMaxNameLength) {
        return NO;
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
    
}

#pragma mark - UiActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    self.userImage = image;
    self.userImageView.image = image;
    [self.userPhotoButton setImage:[UIImage imageNamed:@"ic_cam"] forState:UIControlStateNormal];
    self.userPhotoButton.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
}

@end
