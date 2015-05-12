//
//  KLEventViewController.m
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventViewController.h"
#import "KLEventHeaderView.h"
#import "KLEventFooterView.h"
#import "KLEventDetailsCell.h"
#import "KLEventDescriptionCell.h"
#import "KLEventPaymentCell.h"
#import "KLEventGalleryCell.h"
#import "KLEventLocationCell.h"
#import "KLMapViewController.h"
#import "KLGalleryViewController.h"
#import "KLEventRemindPageCell.h"
#import "KLStaticDataSource.h"
#import "KLInviteFriendsViewController.h"



@interface KLEventViewController () <KLeventPageCellDelegate>

@property (nonatomic, strong) KLEventHeaderView *header;
@property (nonatomic, strong) KLEventFooterView *footer;

@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, strong) KLEventDetailsCell *detailsCell;
@property (nonatomic, strong) KLEventDescriptionCell *descriptionCell;
@property (nonatomic, strong) KLEventPaymentCell *cellPayment;
@property (nonatomic, strong) KLEventLocationCell *cellLocation;
@property (nonatomic, strong) KLEventGalleryCell *cellGallery;
@property (nonatomic, strong) KLEventRemindPageCell *cellReminder;

@end



@implementation KLEventViewController

@dynamic header;

- (instancetype)initWithEvent:(KLEvent *)event
{
    if (self = [super init]) {
        self.event = event;
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
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self layout];
    
    [self updateInfo];
}

- (void)updateFooterMetrics
{
    [self.footer layoutIfNeeded];
    CGSize headerSize = [self.footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    UIView *footer = self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    footer.viewSize = headerSize;
    self.tableView.tableFooterView = footer;
    UIView *flexibleVew = [self.footer flexibleView];
    [flexibleVew autoPinEdge:ALEdgeBottom
                      toEdge:ALEdgeBottom
                      ofView:self.view
                  withOffset:0
                    relation:NSLayoutRelationLessThanOrEqual];
}

- (SFDataSource *)buildDataSource
{
    KLStaticDataSource *dataSource = [[KLStaticDataSource alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"EventDetailsPageCell" bundle:nil];
    self.detailsCell = [nib instantiateWithOwner:nil
                             options:nil].firstObject;
    [self.detailsCell.attendiesButton addTarget:self
                                         action:@selector(showAttendies)
                               forControlEvents:UIControlEventTouchUpInside];
    [self.detailsCell.inviteButton addTarget:self
                                      action:@selector(onInvite)
                            forControlEvents:UIControlEventTouchUpInside];
    [dataSource addItem:self.detailsCell];
    
    nib = [UINib nibWithNibName:@"EventDescriptionCell" bundle:nil];
    self.descriptionCell = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    [dataSource addItem:self.descriptionCell];
    
    
    nib = [UINib nibWithNibName:@"KLEventPaymentCell" bundle:nil];
    self.cellPayment = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellPayment.delegate = self;
    [dataSource addItem:self.cellPayment];
    
    
    nib = [UINib nibWithNibName:@"KLEventLocationCell" bundle:nil];
    self.cellLocation = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellLocation.delegate = self;
    [dataSource addItem:self.cellLocation];
    
    
    nib = [UINib nibWithNibName:@"KLEventGalleryCell" bundle:nil];
    self.cellGallery = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellGallery.delegate = self;
    [dataSource addItem:self.cellGallery];
    
    nib = [UINib nibWithNibName:@"KLEventRemindPageCell" bundle:nil];
    self.cellReminder = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    self.cellReminder.delegate = self;
    [dataSource addItem:self.cellReminder];
    
    return dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    
    __weak typeof(self) weakSelf = self;
    PFQuery *eventQuery = [KLEvent query];
    [eventQuery includeKey:sf_key(owner)];
    [eventQuery includeKey:sf_key(location)];
    
    [eventQuery getObjectInBackgroundWithId:self.event.objectId
                                      block:^(PFObject *object, NSError *error) {
                                          if (!error) {
                                              weakSelf.event = (KLEvent *)object;
                                              [weakSelf updateInfoAfterFetch];
                                          }
                                      }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

- (KLEventHeaderView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"EventHeader" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (KLEventFooterView *)buildFooter
{
    UINib *nib = [UINib nibWithNibName:@"EventFooterView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)updateInfoAfterFetch
{
    [UIView setAnimationsEnabled:NO];
    [self.descriptionCell configureWithEvent:self.event];
    [self.detailsCell configureWithEvent:self.event];
    [self.cellLocation configureWithEvent:self.event];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)updateInfo
{
    [self.header configureWithEvent:self.event];
    [self.detailsCell configureWithEvent:self.event];
    [self.cellLocation configureWithEvent:self.event];
    self.navBarTitle.text = self.event.title;
    [self updateFooterMetrics];
    [super updateInfo];
}

- (void)layout
{
    self.footer = [self buildFooter];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    [footer addSubview:self.footer];
    self.tableView.tableFooterView = footer;
    [UIView autoSetIdentifier:@"Footer Pins to superview" forConstraints:^{
        [self.footer autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.footer autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.footer autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.footer autoSetDimension:ALDimensionWidth toSize:self.view.width];
    }];
    [super layout];
}

#pragma mark - Cells KLeventPageCellDelegate

- (void)galleryCellDidPress:(id)image
{
    KLGalleryViewController *viewController = [[KLGalleryViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)galleryCellAddImageDidPress
{
//    NSLog(@"3");
}

- (void)paypentCellDidPressFree
{
//    NSLog(@"4");
}

- (void)onInvite
{
    KLInviteFriendsViewController *vc = [[KLInviteFriendsViewController alloc] init];
    vc.inviteType = KLInviteTypeEvent;
    vc.isAfterSignIn = NO;
    vc.needBackButton = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAttendies
{
    [self showEventAttendies:self.event];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEventPageCell *cell = ((KLStaticDataSource *)self.dataSource).cells[indexPath.row];
    if (cell == self.descriptionCell) {
        [self showUserProfile:[[KLUserWrapper alloc] initWithUserObject:self.event.owner]];
    } else if(cell == self.cellLocation) {
        KLMapViewController* viewController = [[KLMapViewController alloc] init];
        viewController.location = [[KLLocation alloc] initWithObject:self.event.location];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
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

@end
