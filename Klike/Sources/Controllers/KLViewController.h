//
//  KLViewController.h
//  Klike
//
//  Created by admin on 14/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//TODO add GAI
@interface KLViewController : UIViewController <UIActionSheetDelegate,
                                                UINavigationControllerDelegate,
                                                UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIActionSheet *imagePickerSheet;

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

- (void)showPhotosActionSheet;
- (void)showPhotoViewerWithFile:(PFFile *)file;
- (void)showUserProfile:(KLUserWrapper *)user;

@end
