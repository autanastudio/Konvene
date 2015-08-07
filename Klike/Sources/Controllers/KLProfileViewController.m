//
//  KLProfileViewController.m
//  Klike
//
//  Created by admin on 24/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLProfileViewController.h"
#import "KLUserView.h"
#import "KLFollowersController.h"
#import "SFGalleryController.h"
#import "SFGalleryItem.h"


//@interface KLMHGalleryController : MHGalleryController
//
//@end
//
//
//@implementation KLMHGalleryController
//
//- (id)initWithPresentationStyle:(MHGalleryViewMode)presentationStyle{
//    self = [super init];
//    if (!self)
//        return nil;
//    
//    self.autoplayVideos = NO;
//    
//    self.preferredStatusBarStyleMH = UIStatusBarStyleLightContent;
//    self.presentationStyle = presentationStyle;
//    self.transitionCustomization = MHTransitionCustomization.new;
//    self.UICustomization = MHUICustomization.new;
//    
//    self.imageViewerViewController = MHGalleryImageViewerViewController.new;
//    
//    self.viewControllers = @[self.imageViewerViewController];
//    self.imageViewerViewController.hidesBottomBarWhenPushed = YES;
//    self.hidesBottomBarWhenPushed = YES;
//    
//    
//    self.UICustomization.barStyle = UIBarStyleBlack;
//    self.UICustomization.barTintColor = [UIColor blackColor]; //Default nil
//    self.UICustomization.barButtonsTintColor = [UIColor whiteColor]; //Default nil
//    
////    @property (nonatomic,strong) UIColor *videoProgressTintColor; //Default Black
////    @property (nonatomic)        BOOL showMHShareViewInsteadOfActivityViewController; //Default YES
//    self.UICustomization.hideShare = YES; //Default NO
////    @property (nonatomic)        BOOL useCustomBackButtonImageOnImageViewer; //Default YES
////    @property (nonatomic)        BOOL showOverView; //Default YES
////    @property (nonatomic)        MHBackButtonState backButtonState; //Default MHBackButtonStateWithBackArrow
//
//    
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.navigationBar.backgroundColor = [UIColor blackColor];
//    
//    MHImageViewController *ivc = [self.imageViewerViewController.pageViewController.viewControllers objectAtIndex:0];
//    UIImageView*v = ivc.imageView;
//    v.backgroundColor = [UIColor blackColor];
//}
//
//@end


@interface KLProfileViewController ()
@property (nonatomic, strong) KLUserView *header;
@end



@implementation KLProfileViewController

@dynamic header;

- (instancetype)initWithUser:(KLUserWrapper *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 177.;
    
    [self layout];
    
    [self.header.userFollowersButton addTarget:self
                                        action:@selector(onFollowers)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.header.userFolowingButton addTarget:self
                                       action:@selector(onFollowings)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.header.imagePhotoButton addTarget:self
                                     action:@selector(onPhotoButton)
                           forControlEvents:UIControlEventTouchUpInside];
}

- (SFDataSource *)buildDataSource
{
    return nil;
}

- (KLUserView *)buildHeader
{
    return nil;
}

- (void)updateInfo
{
    [self.header updateWithUser:self.user];
    self.navBarTitle.text = self.user.fullName;
    [self refreshList];
    [super updateInfo];
}

- (void)onFollowers
{
    if (self.user.followers.count) {
        KLFollowersController *followersVC = [[KLFollowersController alloc] initWithType:KLFollowUserListTypeFollowers
                                                                                    user:self.user];
        [self.navigationController pushViewController:followersVC animated:YES];
    }
}

- (void)onFollowings
{
    if (self.user.following.count) {
        KLFollowersController *followingsVC = [[KLFollowersController alloc] initWithType:KLFollowUserListTypeFollowing
                                                                                     user:self.user];
        [self.navigationController pushViewController:followingsVC animated:YES];
    }
}

- (void)onPhotoButton
{
    if (self.user.userImage) {
        SFGalleryItem *item = [SFGalleryItem itemWithImage:self.header.userImageView.image];
        
        NSArray *galleryData = @[item];
        SFGalleryController *gallery = [[SFGalleryController alloc] initWithMediaItems:galleryData];
        
        gallery.presentingFromImageView = self.header.userImageView;
        gallery.currentPageIndex = 0;
        
        
        
        __weak SFGalleryController * weakGallery = gallery;
        gallery.finishedBlock = ^(NSInteger currentIndex,
                                  UIImage *image,
                                  SFGalleryDismissingAnimator *interactiveTransition)
        {
            
            [weakGallery dismissGalleryControllerAnimated:YES toImageView:self.header.userImageView completion:nil];
            
        };
        
        [self presentGalleryController:gallery animated:YES completion:^{
            
        }];
       
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    self.navBarTitle.textColor = [UIColor colorWithWhite:0.
                                                   alpha:alpha];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return 250.;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    [self showEventDetails:[self.dataSource itemAtIndexPath:indexPath]];
}

#pragma  mark - KLEventListDataSourceDelegate methods

- (void)eventListDataSource:(KLEventListDataSource *)dataSource
      showAttendiesForEvent:(KLEvent *)event
{
    [self showEventAttendies:event];
}

@end
