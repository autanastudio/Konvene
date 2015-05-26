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
#import "KLFormMessageView.h"
#import "KLAttendiesList.h"
#import "KLEventViewController.h"

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
    if ([[KLAccountManager sharedManager].currentUser isEqualToUser:user]) {
        KLMyProfileViewController *myProfileViewController = [[KLMyProfileViewController alloc] init];
        [self.navigationController pushViewController:myProfileViewController
                                             animated:YES];
    } else {
        KLUserProfileViewController *userProfileVC = [[KLUserProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:userProfileVC
                                             animated:YES];
    }
}

- (void)showEventDetails:(KLEvent *)event
{
    KLEventViewController *eventVC = [[KLEventViewController alloc] initWithEvent:event];
    eventVC.animated = NO;
    [self.navigationController pushViewController:eventVC
                                         animated:YES];
}

- (void)showEventDetailsAnimated:(KLEvent *)event offset:(CGPoint)offset
{
    KLEventViewController *eventVC = [[KLEventViewController alloc] initWithEvent:event];
    eventVC.animated = YES;
    eventVC.animationOffset = offset;
    eventVC.appScreenshot = [self.view.window imageWithView];
    [self.navigationController pushViewController:eventVC
                                         animated:NO];
}

- (void)showEventAttendies:(KLEvent *)event
{
    KLAttendiesList *attendiesList = [[KLAttendiesList alloc] initWithEvent:event];
    [self.navigationController pushViewController:attendiesList
                                         animated:YES];
}

- (void)showNavbarwithErrorMessage:(NSString *)errorMessage
{
    if (!errorMessage || ![errorMessage notEmpty]) {
        errorMessage = SFLocalized(@"error.default");
    }
    if (errorMessage && self.navigationController) {
        self.blackNavBar = YES;
        KLFormMessageView *messageView = [[KLFormMessageView alloc] initWithMessage:errorMessage];
        [self.navigationController.view addSubview:messageView];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeLeading
                                      withInset:0];
        [messageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing
                                      withInset:0];
        CGSize size = [messageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLayoutConstraint *topPin = [messageView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                                                   withInset:-size.height];
        [messageView layoutIfNeeded];
        [self setNeedsStatusBarAppearanceUpdate];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:.2 animations:^{
            topPin.constant = 0;
            [messageView.superview layoutIfNeeded];
        }];
        [UIView animateWithDuration:.2
                              delay:5
                            options:0
                         animations:^{
                             topPin.constant = -size.height;
                             [messageView.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             weakSelf.blackNavBar = NO;
                             [weakSelf setNeedsStatusBarAppearanceUpdate];
                             [messageView removeFromSuperview];
                         }];
    }
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
