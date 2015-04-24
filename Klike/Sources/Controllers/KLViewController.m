//
//  KLViewController.m
//  Klike
//
//  Created by admin on 14/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"
#import "KLPhotoViewer.h"
#import "KLUserProfileViewController.h"
#import "KLProfileViewController.h"
#import "KLMyProfileViewController.h"

@interface KLViewController () <KLPhotoViewerDelegate>

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showPhotosActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    self.imagePickerSheet = actionSheet;
    [actionSheet showInView:self.view];
}

- (void)showPhotoViewerWithFile:(PFFile *)file
{
    KLPhotoViewer *photoViewer = [[KLPhotoViewer alloc] initWithImageFile:file];
    photoViewer.delegate = self;
    [self presentViewController:photoViewer
                       animated:YES
                     completion:^{
    }];
}

- (void)showUserProfile:(KLUserWrapper *)user
{
    KLUserProfileViewController *userProfileVC = [[KLUserProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:userProfileVC
                                         animated:YES];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KLPhotoViewerDelegate

- (void)photoViewerDidDissmiss
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
