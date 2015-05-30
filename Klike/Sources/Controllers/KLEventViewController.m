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
#import "KLEventPaymentFreeCell.h"
#import "KLEventGalleryCell.h"
#import "KLEventLocationCell.h"
#import "KLMapViewController.h"
#import "KLGalleryViewController.h"
#import "KLEventRemindPageCell.h"
#import "KLCreateEventViewController.h"
#import "KLStaticDataSource.h"
#import "KLInviteFriendsViewController.h"
#import "KLReminderViewController.h"
#import "KLEventRatingPageCell.h"
#import "KLEventPaymentActionPageCell.h"
#import "KLEventPaymentFinishedPageCell.h"
#import "KLEventPaymentInfoPageCell.h"
#import "KLPaymentBaseViewController.h"
#import "KLTicketViewController.h"
#import "KLEventEarniedPageCell.h"
#import "KLEventLoadingPageCell.h"
#import "KLEventGoingForFreePageCell.h"
#import <MessageUI/MessageUI.h>
#import "KLStatsLayoutController.h"



#define SHEET_REPORT 1000



@interface KLEventViewController () <KLeventPageCellDelegate, KLCreateEventDelegate, UIAlertViewDelegate, KLPaymentBaseViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) KLEventHeaderView *header;
@property (nonatomic, strong) KLEventFooterView *footer;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *shareButton;

@property (nonatomic, strong) KLEventDetailsCell *detailsCell;
@property (nonatomic, strong) KLEventDescriptionCell *descriptionCell;
@property (nonatomic, strong) KLEventPaymentFreeCell *cellPayment;
@property (nonatomic, strong) KLEventEarniedPageCell *earniedCell;
@property (nonatomic, strong) KLEventPaymentActionPageCell*cellPaymentAction;
@property (nonatomic, strong) KLEventPaymentInfoPageCell*cellPaymentInfo;
@property (nonatomic, strong) KLEventPaymentFinishedPageCell*cellPaymentFinished;
@property (nonatomic, strong) KLEventLocationCell *cellLocation;
@property (nonatomic, strong) KLEventGalleryCell *cellGallery;
@property (nonatomic, strong) KLEventRemindPageCell *cellReminder;
@property (nonatomic, strong) KLEventRatingPageCell *cellRaiting;
@property (nonatomic, strong) KLEventLoadingPageCell *cellLoading;
@property (nonatomic, strong) KLEventGoingForFreePageCell *cellGoingForFree;

@property (nonatomic) UIImageView *imageScreenshot;

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
    _dataBuilded = NO;
    _paymentState = NO;
    [super viewDidLoad];
    
    if (self.animated) {
        
        UIImageView *image = [[UIImageView alloc] initForAutoLayout];
        [self.view addSubview:image];
        [image  autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height - self.animationOffset.y - 100, 0)];
        image.image = self.appScreenshot;
        image.contentMode = UIViewContentModeTop;
        image.clipsToBounds = YES;
        self.imageScreenshot = image;
        [self.imageScreenshot layoutIfNeeded];
    
    }
    
    self.view.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 177.;
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    self.shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onShare)];
    self.shareButton.tintColor = [UIColor whiteColor];
    
    if ([[KLAccountManager sharedManager] isOwnerOfEvent:self.event]) {
        self.editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_ic_top"]
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(onEdit)];
        self.navigationItem.rightBarButtonItems = @[self.shareButton, self.editButton];
    } else {
        self.navigationItem.rightBarButtonItem = self.shareButton;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UIKeyboardWillShowNotification withBlock:^(NSNotification *notification) {
        CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height)-48., 0.0);// offset 48 for tabBar
        
        [UIView animateWithDuration:rate.floatValue animations:^{
            weakSelf.tableView.contentInset = contentInsets;
        }];
        [weakSelf updateNavigationBarWithAlpha:1.];
        
    }];
    
    [self subscribeForNotification:UIKeyboardWillHideNotification withBlock:^(NSNotification *notification) {
        NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:rate.floatValue animations:^{
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(64., 0., 0., 0.);
        }];
    }];
    
    [self layout];
    
    if (self.needCloseButton) {
        UIButton *button = [[UIButton alloc] initForAutoLayout];
        [self.view addSubview:button];
        [button setImage:[UIImage imageNamed:@"event_close_white"] forState:UIControlStateNormal];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [button autoSetDimensionsToSize:CGSizeMake(44, 44)];
        [button addTarget:self action:@selector(onCloseModal:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self updateNavigationBarWithAlpha:0];
}

- (void)onCloseModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateFooterMetrics
{
    [self.footer layoutIfNeeded];
    CGSize headerSize = [self.footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    UIView *footer = self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    footer.viewSize = headerSize;
    self.tableView.tableFooterView = footer;
    self.tableView.tableFooterView.alpha = 0;
    UIView *flexibleVew = [self.footer flexibleView];
    [flexibleVew autoPinEdge:ALEdgeBottom
                      toEdge:ALEdgeBottom
                      ofView:self.view
                  withOffset:0
                    relation:NSLayoutRelationLessThanOrEqual];
}

- (void)buildDataSourceAfterFetch
{
    if (_dataBuilded) {
        return;
    }
    _dataBuilded = YES;
    KLStaticDataSource *dataSource = (KLStaticDataSource *)self.dataSource;
    
    [dataSource.cells removeObject:self.cellLoading];
    
    UINib *nib = [UINib nibWithNibName:@"KLEventLocationCell" bundle:nil];
    self.cellLocation = [nib instantiateWithOwner:nil
                                          options:nil].firstObject;
    self.cellLocation.delegate = self;
    
    nib = [UINib nibWithNibName:@"KLEventGalleryCell" bundle:nil];
    self.cellGallery = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    self.cellGallery.delegate = self;
    
    
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    if ([self.event isPastEvent]) {
        nib = [UINib nibWithNibName:@"KLEventRatingPageCell" bundle:nil];
        self.cellRaiting = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
        self.cellRaiting.delegate = self;
        [dataSource addItem:self.cellRaiting];
    }
    
    
    KLEventPrice *price = self.event.price;
    KLEventPricingType priceType = price.pricingType.intValue;
    _needActionFinishedCell = NO;
    
    if ([self.event isOwner:[KLAccountManager sharedManager].currentUser]) {
        
        nib = [UINib nibWithNibName:@"KLEventEarniedPageCell" bundle:nil];
        self.earniedCell = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
        
        if (priceType == KLEventPricingTypeFree) {
            [self.earniedCell setType:(KLEventEarniedPageCellFree) numbers:nil];
        }
        else if (priceType == KLEventPricingTypePayed) {
            
            NSMutableArray *numbers = [NSMutableArray array];
            [numbers addObject:price.pricePerPerson];
            [numbers addObject:@(price.youGet)];
            if (price.soldTickets)
                [numbers addObject:price.soldTickets];
            else
                [numbers addObject:@(0)];
            
            [self.earniedCell setType:(KLEventEarniedPageCellPayd) numbers:numbers];
        }
        else if (priceType == KLEventPricingTypeThrow) {
            
            NSMutableArray *numbers = [NSMutableArray array];
            [numbers addObject:price.minimumAmount];
            [numbers addObject:@(price.youGet)];
            [numbers addObject:@(price.payments.count)];
            
            [self.earniedCell setType:(KLEventEarniedPageCellThrow) numbers:numbers];
        }
        
        [dataSource addItem:self.earniedCell];
        
        [dataSource addItem:self.cellLocation];
        [dataSource addItem:self.cellGallery];
    }
    else
    {
        if ([self.event isPastEvent])
        {
            [dataSource addItem:self.cellGallery];
            if (priceType == KLEventPricingTypeFree) {
                nib = [UINib nibWithNibName:@"KLEventEarniedPageCell" bundle:nil];
                self.earniedCell = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
                
                [self.earniedCell setType:(KLEventEarniedPageCellFree) numbers:nil];
                [dataSource addItem:self.earniedCell];
            }
            else if (priceType == KLEventEarniedPageCellPayd)
            {
                if ([[KLEventManager sharedManager] boughtTicketsForEvent:self.event].floatValue > 0)
                {
                    nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
                    self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                                 options:nil].firstObject;
                    self.cellPaymentFinished.delegate = self;
                    [self.cellPaymentFinished setBuyTicketsInfo];
                    [self.cellPaymentFinished setTickets:[[KLEventManager sharedManager] boughtTicketsForEvent:self.event].intValue];
                    if (self.event.backImage)
                        [self.cellPaymentFinished setEventImage:self.header.eventImageView.image];
                    [dataSource addItem:self.cellPaymentFinished];
                    _needActionFinishedCell = YES;
                }
            }
            else if (priceType == KLEventPricingTypeThrow) {
                
                if ([[KLEventManager sharedManager] thrownInForEvent:self.event].floatValue > 0)
                {
                    nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
                    self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                                 options:nil].firstObject;
                    self.cellPaymentFinished.delegate = self;
                    [self.cellPaymentFinished setThrowInInfo];
                    [self.cellPaymentFinished setThrowedIn:[[KLEventManager sharedManager] thrownInForEvent:self.event].floatValue];
                    if (self.event.backImage)
                        [self.cellPaymentFinished setEventImage:self.header.eventImageView.image];
                    [dataSource addItem:self.cellPaymentFinished];
                    _needActionFinishedCell = YES;
                }
            }
            
            [dataSource addItem:self.cellLocation];
        }
        else
        {
            if (priceType == KLEventPricingTypeFree)
            {
                nib = [UINib nibWithNibName:@"KLEventPaymentFreeCell" bundle:nil];
                self.cellPayment = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
                self.cellPayment.delegate = self;
                
                if ([self.event.attendees containsObject:user.userObject.objectId])
                    [self.cellPayment setState:KLEventPaymentFreeCellStateGoing];
                else
                    [self.cellPayment setState:KLEventPaymentFreeCellStateGo];
                [dataSource addItem:self.cellPayment];
            }
            else
            {
                nib = [UINib nibWithNibName:@"KLEventPaymentActionPageCell" bundle:nil];
                self.cellPaymentAction = [nib instantiateWithOwner:nil
                                                           options:nil].firstObject;
                self.cellPaymentAction.delegate = self;
                
                if (priceType == KLEventPricingTypePayed) {
                    
                    if ([[KLEventManager sharedManager] boughtTicketsForEvent:self.event].floatValue > 0)
                    {
                        nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
                        self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                                     options:nil].firstObject;
                        self.cellPaymentFinished.delegate = self;
                        [self.cellPaymentFinished setBuyTicketsInfo];
                        [self.cellPaymentFinished setTickets:[[KLEventManager sharedManager] boughtTicketsForEvent:self.event].intValue];
                        if (self.event.backImage)
                            [self.cellPaymentFinished setEventImage:self.header.eventImageView.image];
                        [dataSource addItem:self.cellPaymentFinished];
                        _needActionFinishedCell = YES;
                    }
                    [self.cellPaymentAction setLeftValue:self.event.price.pricePerPerson];
                    [self.cellPaymentAction setBuyTicketsInfo];
                }
                else if (priceType == KLEventPricingTypeThrow) {
                    
                    if ([[KLEventManager sharedManager] thrownInForEvent:self.event].floatValue > 0)
                    {
                        nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
                        self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                                     options:nil].firstObject;
                        self.cellPaymentFinished.delegate = self;
                        [self.cellPaymentFinished setThrowInInfo];
                        [self.cellPaymentFinished setThrowedIn:[[KLEventManager sharedManager] thrownInForEvent:self.event].floatValue];
                        if (self.event.backImage)
                            [self.cellPaymentFinished setEventImage:self.header.eventImageView.image];
                        [dataSource addItem:self.cellPaymentFinished];
                        _needActionFinishedCell = YES;
                    }
                    [self.cellPaymentAction setLeftValue:self.event.price.throwIn];
                    [self.cellPaymentAction setThrowInInfo];
                    
                    
                }
                
                [dataSource addItem:self.cellPaymentAction];
                
                if (priceType == KLEventPricingTypeThrow &&
                    self.event.price.minimumAmount.intValue < 1 &&
                    [[KLEventManager sharedManager] thrownInForEvent:self.event].intValue < 1) {
                    
                    nib = [UINib nibWithNibName:@"KLEventGoingForFreePageCell" bundle:nil];
                    self.cellGoingForFree = [nib instantiateWithOwner:nil
                                                              options:nil].firstObject;
                    self.cellGoingForFree.delegate = self;
                    
                    [self.cellGoingForFree setActive:![self.event.attendees containsObject:user.userObject.objectId]];
                    
                    [dataSource addItem:self.cellGoingForFree];
                }
            }
            [dataSource addItem:self.descriptionCell];
            
            
            nib = [UINib nibWithNibName:@"KLEventRemindPageCell" bundle:nil];
            self.cellReminder = [nib instantiateWithOwner:nil
                                                  options:nil].firstObject;
            self.cellReminder.delegate = self;
            
            
            
            [dataSource addItem:self.cellLocation];
            [dataSource addItem:self.cellGallery];
            
            [dataSource addItem:self.cellReminder];
        }
    }
}

- (SFDataSource *)buildDataSource
{
    KLStaticDataSource *dataSource = [[KLStaticDataSource alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"EventDetailsPageCell" bundle:nil];
    self.detailsCell = [nib instantiateWithOwner:nil
                             options:nil].firstObject;
    self.detailsCell.delegate = self;
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
    
    self.cellLoading = [[KLEventLoadingPageCell alloc] init];
    [self.cellLoading build];
    [dataSource addItem:self.cellLoading];
    
        
    return dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    
    [self reloadEvent];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.animated) {
        self.animated = NO;
        CGAffineTransform t = CGAffineTransformMakeTranslation(self.animationOffset.x, self.animationOffset.y);
        self.tableView.transform = t;
        
        
        UIView *view1 = [self.navigationItem.leftBarButtonItem valueForKey:@"view"];
        UIView *view2 = [self.navigationItem.rightBarButtonItem valueForKey:@"view"];
        t = CGAffineTransformMakeTranslation(0, 15);
        view1.transform = t;
        view2.transform = t;
        view1.alpha = 0;
        view2.alpha = 0;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.tableView.transform = CGAffineTransformIdentity;
                             self.imageScreenshot.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self.imageScreenshot removeFromSuperview];
                             self.imageScreenshot = nil;
                         }];
        
        [UIView animateWithDuration:0.25 delay:0.25 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            view1.transform = CGAffineTransformIdentity;
            view2.transform = CGAffineTransformIdentity;
            view1.alpha = 1;
            view2.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        [self.header startAppearAnimation];
        
    }
}

- (void)reloadEvent
{
    __weak typeof(self) weakSelf = self;
    PFQuery *eventQuery = [KLEvent query];
    [eventQuery includeKey:sf_key(owner)];
    [eventQuery includeKey:sf_key(location)];
    [eventQuery includeKey:sf_key(price)];
    [eventQuery includeKey:sf_key(extension)];
    [eventQuery includeKey:[NSString stringWithFormat:@"%@.%@", sf_key(price), sf_key(payments)]];
    
    NSString *eventId = self.event.objectId;
    [eventQuery getObjectInBackgroundWithId:eventId
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
    [self buildDataSourceAfterFetch];
    [self.descriptionCell configureWithEvent:self.event];
    [self.detailsCell configureWithEvent:self.event];
    [self.cellLocation configureWithEvent:self.event];
    [self.cellGallery configureWithEvent:self.event];
    [self.cellReminder configureWithEvent:self.event];
    [self.cellPaymentFinished configureWithEvent:self.event];
    [self.cellRaiting configureWithEvent:self.event];
    [self.cellPaymentAction configureWithEvent:self.event];
    [self.cellGoingForFree configureWithEvent:self.event];
    [self.footer configureWithEvent:self.event];
    [self.tableView reloadData];
    self.tableView.tableFooterView.alpha = 1;
    [UIView setAnimationsEnabled:YES];
    
//    self.tableView.hidden = NO;
}

static NSInteger maxTitleLengthForOwnEvent = 15;
static NSInteger maxTitleLengthForEvent = 25;

- (void)updateInfo
{
    [self.detailsCell configureWithEvent:self.event];
    [self.cellLocation configureWithEvent:self.event];
    NSString *titleString = self.event.title;
    NSInteger maxLength = 0;
    if ([self.event isOwner:[KLAccountManager sharedManager].currentUser]) {
        maxLength = maxTitleLengthForOwnEvent;
    } else {
        maxLength = maxTitleLengthForEvent;
    }
    if (titleString.length>maxLength) {
        titleString = [NSString stringWithFormat:@"%@...", [titleString substringToIndex:maxLength-1]];
    }
    self.navBarTitle.text = titleString;
    [self updateFooterMetrics];
    [super updateInfo];
    [self.header configureWithEvent:self.event];
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
    viewController.event = self.event;
    viewController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)galleryCellAddImageDidPress
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SFLocalized(@"locationCancel") destructiveButtonTitle:nil otherButtonTitles:SFLocalized(@"evetnAddPhotoTake"), SFLocalized(@"evetnAddPhotoLibrary"), nil];
    [actionSheet showInView:self.view];
    self.imagePickerSheet = actionSheet;
}

- (void)paypentCellDidPressFree
{
//    if ([self.event.attendees containsObject:[KLAccountManager sharedManager].currentUser.userObject.objectId] ||
//        self.cellPayment.state == KLEventPaymentFreeCellStateGoing)
//        return;
    
    if ([self.event.attendees containsObject:[KLAccountManager sharedManager].currentUser.userObject.objectId])
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Decided not to go?" message:@"" delegate:self cancelButtonTitle:@"Will go!" otherButtonTitles:@"No", nil];
        view.tag = 1000;
        [view show];
    }
    else
    {
        
        [[KLEventManager sharedManager] attendEvent:self.event completition:^(id object, NSError *error) {
            if (!error) {
                KLEvent *event = object;
                self.event.attendees = event.attendees;
                [self.cellPayment setState:(KLEventPaymentFreeCellStateGoing)];
            }
        }];
    }
}

- (void)paymentActionCellDidPressAction
{
    
    KLEventPrice *price = self.event.price;
    KLEventPricingType priceType = price.pricingType.intValue;

    if (_paymentState) {
        
        if (self.cellPaymentInfo.number.intValue < 1) {
            return;
        }
        //action!
        
        NSString *title = @"";
        NSString *action = @"";
        
        
        if (priceType == KLEventPricingTypePayed)
        {
            
            title = [NSString stringWithFormat:@"Are you shure you want to buy %d tickets for $%d?", self.cellPaymentInfo.number.intValue, self.cellPaymentInfo.number.intValue * self.event.price.pricePerPerson.intValue];
            action = @"Buy";
        }
        else if (priceType == KLEventPricingTypeThrow) {
            title = [NSString stringWithFormat:@"Are you shure you want to throw in $%d?", self.cellPaymentInfo.number.intValue];
            action = @"Throw in";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
        [alert show];
    }
    else
    {
        KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
        KLUserPayment *payments = user.paymentInfo;
        
        if (payments.isDataAvailable && payments.cards.count > 0)
        {
            [self setPaymentInfoCellVisible:YES];
            _paymentState = YES;
        }
        else
        {
            KLPaymentBaseViewController *vc = [[KLPaymentBaseViewController alloc] init];
            vc.throwInStyle = priceType == KLEventPricingTypeThrow;
            vc.event = self.event;
            vc.delegate = self;
            [self.navigationController presentViewController:vc animated:YES completion:^{
                
            }];
            
        }
    }
}

- (void)paymentBaseViewControllerDidFinishPayment
{
    [self reloadEvent];
    [self setPaymentFinishedCellVisible:YES];
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    [self.cellGoingForFree setActive:![self.event.attendees containsObject:user.userObject.objectId]];
}

- (void)onInvite
{
    KLInviteFriendsViewController *vc = [[KLInviteFriendsViewController alloc] init];
    vc.inviteType = KLInviteTypeEvent;
    vc.isAfterSignIn = NO;
    vc.needBackButton = YES;
    vc.event = self.event;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onEdit
{
    KLCreateEventViewController *createController = [[KLCreateEventViewController alloc] initWithType:KLCreateEventViewControllerTypeEdit event:self.event];
    createController.delegate = self;
    [self.navigationController pushViewController:createController animated:YES];
}

- (void)paymentFinishedCellDidPressTicket
{
    KLTicketViewController *ticketVC = [[KLTicketViewController alloc] init];
    ticketVC.event = self.event;
    if (self.event.backImage)
        ticketVC.eventImage = self.header.eventImageView.image;
    [self presentViewController:ticketVC
                       animated:YES
                     completion:^{
                     }];
}

- (void)onShare
{
    NSString *shareString = [@"I'm going to " stringByAppendingString:self.event.title];

    
    if (self.event.location)
    {
        shareString = [shareString stringByAppendingString:@" @ "];
        KLLocation* location = [[KLLocation alloc] initWithObject:self.event.location];
        shareString = [shareString stringByAppendingString:location.name];
    }
    shareString = [shareString stringByAppendingString:@" on "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    formatter.timeStyle = kCFDateFormatterShortStyle;
    shareString = [shareString stringByAppendingString:[formatter stringFromDate:self.event.startDate]];
    
    UIImage *shareImage = self.header.eventImageView.image;
    NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://konveneapp.com/share/event.html?eventId=%@", self.event.objectId]];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
    
    _activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    _activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:_activityViewController animated:YES completion:nil];
    
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAttendies
{
    [self showEventAttendies:self.event];
}

- (void)showStatsController
{
    KLStatsLayoutController *controller = [[KLStatsLayoutController alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reminderCellDidSavePress
{
    static BOOL _requestSent = NO;
    if (_requestSent)
        return;
    
    
    __weak typeof(self) weakSelf = self;
    _requestSent = YES;
    KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
    [[KLEventManager sharedManager] saveEvent:self.event
                                         save:![self.event.savers containsObject:currentUser.userObject.objectId]
                                 completition:^(id object, NSError *error) {
                                     _requestSent = NO;
                                     if (!error) {
                                         weakSelf.event = object;
                                         [weakSelf.cellReminder configureWithEvent:weakSelf.event];
                                     }
                                 }];
}

- (void)detailsCellDidPressReport
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report via email", nil];
    [sheet showInView:self.view];
    sheet.tag = SHEET_REPORT;
    return;
    
}

- (void)ratingCellDidPressRate:(NSNumber*)number
{
    __weak typeof(self) weakSelf = self;
    [[KLEventManager sharedManager] voteForEvent:self.event
                                       withValue:number
                                    completition:^(id object, NSError *error) {
                                        if (!error) {
                                            KLEvent *newEvent = object;
                                            self.event = newEvent;
                                            [weakSelf.cellRaiting setRating:[self.event.extension getVoteAverage]
                                                                   animated:YES];
                                            
                                            [weakSelf updateInfoAfterFetch];
                                        }
    }];
}

- (void)paymentInfoCellDidPressClose
{
    _paymentState = NO;
    
    if (_needActionFinishedCell) {
        [self.tableView beginUpdates];
    }
    
    [self setPaymentInfoCellVisible:NO];
    
    if (_needActionFinishedCell) {
        [self.tableView endUpdates];
    }
}

- (void)reminderCellDidRemindPress
{
    KLReminderViewController *reminders = [[KLReminderViewController alloc] init];
    reminders.event = self.event;
    [self.navigationController pushViewController:reminders animated:YES];
}

- (void)goingForFreeCellDidPressGo
{
    [[KLEventManager sharedManager] attendEvent:self.event completition:^(id object, NSError *error) {
        if (!error) {
            KLEvent *event = object;
            self.event.attendees = event.attendees;
            [self.cellGoingForFree setActive:NO];
        }
    }];
}

- (void)setPaymentInfoCellVisible:(BOOL)visible
{
    if (!self.cellPaymentInfo)
    {
        UINib *nib = [UINib nibWithNibName:@"KLEventPaymentInfoPageCell" bundle:nil];
        self.cellPaymentInfo = [nib instantiateWithOwner:nil
                                                 options:nil].firstObject;
        self.cellPaymentInfo.delegate = self;
        KLEventPrice *price = self.event.price;
        KLEventPricingType priceType = price.pricingType.intValue;
        if (priceType == KLEventPricingTypePayed)
            [self.cellPaymentInfo setBuy];
        else
            [self.cellPaymentInfo setThrowIn];
        
        [self.cellPaymentInfo configureWithEvent:self.event];
        
    }
    
    KLStaticDataSource *staticDataSource = (KLStaticDataSource *)self.dataSource;
    if (visible == [staticDataSource.cells containsObject:self.cellPaymentInfo])
        return;
    
    NSUInteger index = [staticDataSource.cells indexOfObject:self.cellPaymentAction] - 1;
    BOOL reload = NO;
    if ([staticDataSource.cells containsObject:self.cellPaymentFinished]) {
        reload = YES;
//        [staticDataSource.cells removeObject:self.cellPaymentFinished];
    }
    else if (visible)
        index ++;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (visible)
    {
        if ([staticDataSource.cells containsObject:self.cellPaymentFinished]) {
            [self.cellPaymentInfo configureWithEvent:self.event];
            [staticDataSource.cells removeObject:self.cellPaymentFinished];
            [staticDataSource.cells insertObject:self.cellPaymentInfo atIndex:index];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            [self.cellPaymentInfo startAppearAnimation];
        }
        else
        {
            [self.cellPaymentInfo configureWithEvent:self.event];
            [staticDataSource.cells insertObject:self.cellPaymentInfo atIndex:index];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            [self.cellPaymentInfo startAppearAnimation];
        }
    }
    else
    {
        if (_needActionFinishedCell)
        {
            [self.cellPaymentInfo startDisappearAnimation:^{
                
                if (!self.cellPaymentFinished) {
                    UINib *nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
                    self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                                 options:nil].firstObject;
                    self.cellPaymentFinished.delegate = self;
                    [self.cellPaymentFinished configureWithEvent:self.event];
                }

                
                NSUInteger index = [staticDataSource.cells indexOfObject:self.cellPaymentInfo];
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                
                [staticDataSource.cells removeObject:self.cellPaymentInfo];
                [staticDataSource.cells insertObject:self.cellPaymentFinished atIndex:index];
                [self.cellPaymentFinished configureWithEvent:self.event];
                [self.cellPaymentFinished beforeAppearAnimation];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
                
                [self.tableView beginUpdates];
                [self.cellPaymentFinished startAppearAnimation];
                [self.tableView endUpdates];
                
            }];
        }
        else
        {
            [self.cellPaymentInfo startDisappearAnimation:^{
                
            }];
            [staticDataSource.cells removeObject:self.cellPaymentInfo];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            
        }
    }
}

- (void)setPaymentFinishedCellVisible:(BOOL)visible
{
    if (!self.cellPaymentFinished) {
        UINib *nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
        self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
        self.cellPaymentFinished.delegate = self;
        [self.cellPaymentFinished configureWithEvent:self.event];
    }
    
    
    KLStaticDataSource *staticDataSource = (KLStaticDataSource *)self.dataSource;
    if (visible == [staticDataSource.cells containsObject:self.cellPaymentFinished])
        return;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    if (visible) {
        [staticDataSource.cells insertObject:self.cellPaymentFinished atIndex:2];
        if (self.event.backImage)
            [self.cellPaymentFinished setEventImage:self.header.eventImageView.image];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }
    else {
        [staticDataSource.cells removeObject:self.cellPaymentFinished];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEventPageCell *cell = ((KLStaticDataSource *)self.dataSource).cells[indexPath.row];
    if (cell == self.descriptionCell) {
        [self showUserProfile:[[KLUserWrapper alloc] initWithUserObject:self.event.owner]];
    } else if(cell == self.cellLocation) {
        KLMapViewController* viewController = [[KLMapViewController alloc] init];
        viewController.event = self.event;
        viewController.location = [[KLLocation alloc] initWithObject:self.event.location];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    } else if (cell == self.earniedCell) {
        KLEventPricingType type = [self.event.price.pricingType integerValue];
        if (type!=KLEventPricingTypeFree) {
            [self showStatsController];
        }
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
    self.editButton.tintColor = navBarElementsColor;
    self.shareButton.tintColor = navBarElementsColor;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
    
    [[KLEventManager sharedManager] addToEvent:self.event image:image completition:^(BOOL succeeded, NSError *error) {
        [self reloadEvent];
    }];
    
}

#pragma mark - KLCreateEventControllerDelegate

- (void)dissmissCreateEventViewController:(KLCreateEventViewController *)controller
                                 newEvent:(KLEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
    self.event = event;
    [self updateInfo];
    [self reloadEvent];
}

#pragma mark - UIAlertViewDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [[KLEventManager sharedManager] attendEvent:self.event
                                           completition:^(id object, NSError *error) {
                                               if (!error) {
                                                   KLEvent *event = object;
                                                   self.event.attendees = event.attendees;
                                                   [self.cellPayment setState:(KLEventPaymentFreeCellStateGo)];
                                               }
            }];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            KLEventPrice *price = self.event.price;
            KLEventPricingType priceType = price.pricingType.intValue;
            
            if (priceType == KLEventPricingTypePayed) {
                [[KLEventManager sharedManager] buyTickets:self.cellPaymentInfo.number
                                                      card:self.cellPaymentInfo.card
                                                  forEvent:self.event completition:^(id object, NSError *error) {
                                                      if(object) {
                                                          KLEvent *newEvent = object;
                                                          self.event.price = newEvent.price;
                                                          [self onCharged];
                                                      }
                                                  }];
            }
            else if (priceType == KLEventPricingTypeThrow) {
                [[KLEventManager sharedManager] payAmount:self.cellPaymentInfo.number
                                                     card:self.cellPaymentInfo.card
                                                 forEvent:self.event completition:^(id object, NSError *error) {
                                                     if(object) {
                                                         KLEvent *newEvent = object;
                                                         self.event.price = newEvent.price;
                                                         [self onCharged];
                                                     }
                                                 }];
            }
        }
    }
}

- (void)onCharged
{
    [self reloadEvent];
    
    _paymentState = NO;
    if (!self.cellPaymentFinished) {
        UINib *nib = [UINib nibWithNibName:@"KLEventPaymentFinishedPageCell" bundle:nil];
        self.cellPaymentFinished = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
        self.cellPaymentFinished.delegate = self;

    }
    KLEventPrice *price = self.event.price;
    KLEventPricingType priceType = price.pricingType.intValue;
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    
    if (priceType == KLEventPricingTypePayed) {
        [self.cellPaymentFinished setBuyTicketsInfo];
        [self.cellPaymentFinished setTickets:[[KLEventManager sharedManager] boughtTicketsForEvent:self.event].intValue];
        
        _needActionFinishedCell = [[KLEventManager sharedManager] boughtTicketsForEvent:self.event].floatValue > 0;
    }
    else if (priceType == KLEventPricingTypeThrow) {
        [self.cellPaymentFinished setThrowInInfo];
        [self.cellPaymentFinished setThrowedIn:[[KLEventManager sharedManager] thrownInForEvent:self.event].intValue];
        
        _needActionFinishedCell = [[KLEventManager sharedManager] thrownInForEvent:self.event].floatValue > 0;
    }
    [self.tableView beginUpdates];
    [self setPaymentInfoCellVisible:NO];
    [self.cellGoingForFree setActive:![self.event.attendees containsObject:user.userObject.objectId]];
    [self.tableView endUpdates];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SHEET_REPORT)
    {
        if (buttonIndex == 0) {
            
            if (![MFMailComposeViewController canSendMail])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail"
                                                                message:SFLocalized(@"profileEmailError")
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"Konvene feedback"];
            
            NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://konveneapp.com/share/event.html?eventId=%@", self.event.objectId]];
            
            [mail setMessageBody:shareUrl.absoluteString isHTML:NO];
            [mail setToRecipients:@[@"support@konveneapp.com"]];
            
            
            
            [self presentViewController:mail animated:YES completion:NULL];
        }
        return;
    }
    
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end





