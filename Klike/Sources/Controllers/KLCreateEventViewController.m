//
//  KLCreateEventViewController.m
//  Klike
//
//  Created by admin on 06/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCreateEventViewController.h"
#import "KLCreateEventHeaderView.h"
#import "SFBasicDataSource.h"
#import "KLFormDataSource.h"
#import "KLFormCell.h"
#import "KLBasicFormCell.h"
#import "KLSettingCell.h"
#import "SFComposedDataSource.h"
#import "KLDescriptionCell.h"
#import "SFTextField.h"
#import "KLDateCell.h"
#import "KLTimePickerCell.h"
#import "KLLocationSelectTableViewController.h"
#import "KLMultiLineTexteditForm.h"
#import "KLSegmentedController.h"
#import "KLPricingController.h"
#import "KLEvent.h"
#import "KLAccountManager.h"
#import "KLForsquareVenue.h"
#import "KLEnumViewController.h"

@interface KLCreateEventViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KLEnumViewControllerDelegate, KLLocationSelectTableViewControllerDelegate, KLPricingDelegate>

@property (nonatomic, strong) UIView *navigationBarAnimationBG;
@property (nonatomic, strong) UILabel *navBarTitle;

@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

//FormCells
@property (nonatomic, strong) KLBasicFormCell *nameInput;
@property (nonatomic, strong) KLMultiLineTexteditForm *descriptionInput;

@property (nonatomic, strong) KLFormDataSource *dateAndLocationForm;
@property (nonatomic, strong) KLDateCell *startDateInput;
@property (nonatomic, strong) KLTimePickerCell *startDatePicker;
@property (nonatomic, strong) KLDateCell *endDateInput;
@property (nonatomic, strong) KLTimePickerCell *endDatePicker;
@property (nonatomic, strong) KLSettingCell *locationInput;

@property (nonatomic, strong) KLDescriptionCell *privacyInput;

@property (nonatomic, strong) KLSettingCell *eventTypeInput;
@property (nonatomic, strong) KLBasicFormCell *dresscodeInput;

//Data
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLCreateEventViewController

- (void)dealloc
{
    self.tableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self layout];
    
    [self.header.addPhotoButton addTarget:self
                                   action:@selector(showPhotosActionSheet)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.header.editPhotoButton addTarget:self
                                    action:@selector(showPhotosActionSheet)
                          forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"event_close_white"]
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(onClose)];
    self.navigationItem.leftBarButtonItem = self.closeButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"event_right_arr_whight"]
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(onNext)];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    __weak typeof(self) weakSelf = self;
    [self subscribeForNotification:UITextViewTextDidChangeNotification
                         withBlock:^(NSNotification *notification) {
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView endUpdates];
    }];
    
    [self subscribeForNotification:UIKeyboardWillShowNotification withBlock:^(NSNotification *notification) {
        CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
        
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)updateHeaderMertics
{
    [self.header layoutIfNeeded];
    CGSize headerSize = [self.header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    UIView *header = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    header.viewSize = headerSize;
    self.tableView.tableHeaderView = header;
    [self.header.photoImageView autoPinEdge:ALEdgeTop
                                     toEdge:ALEdgeTop
                                     ofView:self.view
                                 withOffset:0
                                   relation:NSLayoutRelationLessThanOrEqual];
    
}

- (KLCreateEventHeaderView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"CreateEventHeader" bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (void)updateInfo
{
    self.navBarTitle.text = @"NEW EVENT";
    [self updateHeaderMertics];
}

- (SFDataSource *)buildDataSource
{
    SFComposedDataSource *form = [[SFComposedDataSource alloc] init];
    
    KLFormDataSource *nameAndDescription = [[KLFormDataSource alloc] init];
    
    self.nameInput = [[KLBasicFormCell alloc] initWithName:@"Name"
                                               placeholder:@"Name"
                                                     image:[UIImage imageNamed:@"event_name_x1"]];
    self.nameInput.minimumHeight = 64.;
    self.nameInput.iconInsets = UIEdgeInsetsMake(22., 15., 0, 0);
    self.descriptionInput = [[KLMultiLineTexteditForm alloc] initWithName:@"Description"
                                                              placeholder:@"Description"
                                                                    image:[UIImage imageNamed:@"event_desc_x1"]];
    self.descriptionInput.minimumHeight = 60.;
    self.descriptionInput.iconInsets = UIEdgeInsetsMake(22., 15., 0, 0);
    
    [nameAndDescription addFormInput:self.nameInput];
    [nameAndDescription addFormInput:self.descriptionInput];
    
    self.dateAndLocationForm = [[KLFormDataSource alloc] init];
    
    self.startDateInput = [[KLDateCell alloc] initWithName:@"Start"
                                                     image:[UIImage imageNamed:@"event_start"]
                                                     title:@"Start"
                                                     value:[NSDate date]];
    self.startDateInput.iconInsets = UIEdgeInsetsMake(14., 16., 0, 0);
    self.startDatePicker = [[KLTimePickerCell alloc] init];
    self.startDatePicker.delegate = self.startDateInput;
    self.endDateInput = [[KLDateCell alloc] initWithName:@"Start"
                                                   image:[UIImage imageNamed:@"event_end"]
                                                   title:@"End (optional)"
                                                   value:nil];
    self.endDateInput.iconInsets = UIEdgeInsetsMake(14., 16., 0, 0);
    self.endDatePicker = [[KLTimePickerCell alloc] init];
    self.endDatePicker.delegate = self.endDateInput;
    self.locationInput = [[KLSettingCell alloc] initWithName:@"Location"
                                                       image:[UIImage imageNamed:@"event_pin"]
                                                       title:@"Location"
                                                       value:nil];
    self.locationInput.iconInsets = UIEdgeInsetsMake(14., 16., 0, 0);
    self.locationInput.minimumHeight = 44;
    
    [self.dateAndLocationForm addFormInput:self.startDateInput];
    [self.dateAndLocationForm addFormInput:self.endDateInput];
    [self.dateAndLocationForm addFormInput:self.locationInput];
    
    KLFormDataSource *privacy = [[KLFormDataSource alloc] init];
    
    KLEnumObject *defaultPrivacy = [[KLEventManager sharedManager] privacyTypeEnumObjects][0];
    self.privacyInput = [[KLDescriptionCell alloc] initWithName:@"Privacy"
                                                          image:[UIImage imageNamed:@"event_public"]
                                                          title:@"Privacy"
                                                          value:defaultPrivacy];
    self.privacyInput.iconInsets = UIEdgeInsetsMake(15., 16., 0, 0);
    
    [privacy addFormInput:self.privacyInput];
    
    KLFormDataSource *details = [[KLFormDataSource alloc] init];
    
    self.eventTypeInput = [[KLSettingCell alloc] initWithName:@"type"
                                                        image:[UIImage imageNamed:@"ic_event_type_01"]
                                                        title:@"Event Type (optional)"
                                                        value:nil];
    self.eventTypeInput.iconInsets = UIEdgeInsetsMake(11., 10., 0, 0);
    self.eventTypeInput.minimumHeight = 52.;
    self.dresscodeInput = [[KLBasicFormCell alloc] initWithName:@"dresscode"
                                                    placeholder:@"Dresscode (optional)"
                                                          image:[UIImage imageNamed:@"event_dress"]
                                                          value:nil];
    self.dresscodeInput.iconInsets = UIEdgeInsetsMake(11., 16., 0, 0);
    self.dresscodeInput.minimumHeight = 40;
    self.dresscodeInput.textField.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                          size:14.];
    
    [details addFormInput:self.eventTypeInput];
    [details addFormInput:self.dresscodeInput];
    
    [form addDataSource:nameAndDescription];
    [form addDataSource:self.dateAndLocationForm];
    [form addDataSource:privacy];
    [form addDataSource:details];
    
    return form;
}

- (void)fillEventWithData
{
    if (!self.event) {
        self.event = [KLEvent object];
    }
    [self.event kl_setObject:self.nameInput.value
                      forKey:sf_key(title)];
    [self.event kl_setObject:self.descriptionInput.value
                      forKey:sf_key(description)];
    [self.event kl_setObject:self.startDateInput.value
                      forKey:sf_key(startDate)];
    if (self.endDateInput.value) {
        [self.event kl_setObject:self.endDateInput.value
                          forKey:sf_key(endDate)];
    }
    
    KLForsquareVenue *venue = self.locationInput.value;
    if (venue) {
        [self.event kl_setObject:venue.venueObject forKey:sf_key(location)];
    }
    KLEnumObject *privacyObject = self.privacyInput.value;
    [self.event kl_setObject:@(privacyObject.enumId)
                      forKey:sf_key(privacy)];
    KLEnumObject *typeObject = self.eventTypeInput.value;
    if (typeObject) {
        [self.event kl_setObject:@(typeObject.enumId)
                          forKey:sf_key(eventType)];
    }
    [self.event kl_setObject:self.dresscodeInput.value
                      forKey:sf_key(dresscode)];
    
    if (self.backImage) {
        [self.event updateEventBackImage:self.backImage];
    }
    self.event.owner = [KLAccountManager sharedManager].currentUser.userObject;
}

#pragma mark - Actions

- (void)onClose
{
    [self.delegate dissmissCreateEventViewController];
}

- (void)onNext
{
    [self fillEventWithData];
    KLPricingController *priceController = [[KLPricingController alloc] initWithEvent:self.event];
    priceController.delegate = self;
    [self.navigationController pushViewController:priceController
                                         animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
    self.backImage = image;
    [self.header setBackImage:image];
    [self updateHeaderMertics];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.startDateInput) {
        [self tooggleDateCell:self.startDatePicker];
        return;
    } else if ( cell == self.endDateInput) {
        if (self.endDateInput.value) {
            self.endDatePicker.date = self.endDateInput.value;
        } else {
            self.endDatePicker.date = self.startDateInput.value;
        }
        [self.endDatePicker setMinimalDate:self.startDateInput.value];
        [self tooggleDateCell:self.endDatePicker];
        return;
    } else if (cell == self.eventTypeInput) {
        KLEnumViewController *enumVc = [[KLEnumViewController alloc] initWithTitle:SFLocalized(@"event.type.title")
                                                                      defaultvalue:self.eventTypeInput.value
                                                                       enumObjects:[[KLEventManager sharedManager]
                                                                                    eventTypeEnumObjects]];
        enumVc.delegate = self;
        [self.navigationController pushViewController:enumVc
                                             animated:YES];
    } else if (cell == self.privacyInput) {
        KLEnumViewController *enumVc = [[KLEnumViewController alloc] initWithTitle:SFLocalized(@"event.privacy.window_title")
                                                                      defaultvalue:self.privacyInput.value
                                                                       enumObjects:[[KLEventManager sharedManager]
                                                                                    privacyTypeEnumObjects]];
        enumVc.delegate = self;
        [self.navigationController pushViewController:enumVc
                                             animated:YES];
    } else if (cell == self.locationInput) {
        KLLocationSelectTableViewController *location = [[KLLocationSelectTableViewController alloc] initWithType:KLLocationSelectTypeFoursquare];
        location.delegate = self;
        [self.navigationController pushViewController:location
                                             animated:YES];
    }
    KLFormCell *activeCell = [self activePickerCell];
    if (activeCell) {
        [self tooggleDateCell:activeCell];
    }
}

- (KLTimePickerCell *)activePickerCell
{
    if ([self.dateAndLocationForm.formCells containsObject:self.startDatePicker]) {
        return self.startDatePicker;
    } else if ([self.dateAndLocationForm.formCells containsObject:self.endDatePicker]) {
        return self.endDatePicker;
    }
    return nil;
}

- (void)tooggleDateCell:(KLFormCell *)cell
{
    KLFormCell *activeCell = [self activePickerCell];
    KLDateCell *dateCell = (KLDateCell *)cell.delegate;
    NSIndexPath *inputIndexPath = [self.dataSource indexPathsForItem:dateCell][0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inputIndexPath.row+1
                                                inSection:inputIndexPath.section];
    BOOL hidden = cell!=activeCell;
    if (hidden) {
        if (activeCell) {
            [self tooggleDateCell:activeCell];
            if (activeCell == self.startDatePicker) {
                indexPath = [NSIndexPath indexPathForRow:inputIndexPath.row
                                               inSection:inputIndexPath.section];
            }
        }
        dateCell.valueLabel.textColor = [UIColor colorFromHex:0x6466ca];
        [self.dateAndLocationForm.formCells insertObject:cell atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    } else {
        dateCell.valueLabel.textColor = [UIColor colorFromHex:0x91919f];
        [self.dateAndLocationForm.formCells removeObject:cell];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat alpha = (scrollView.contentOffset.y + scrollView.contentInset.top - self.tableView.tableHeaderView.height + 64) / 64;
        [self updateNavigationBarWithAlpha:MIN(alpha, 1.)];
    }
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    self.navigationBarAnimationBG.alpha = alpha;
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.navBarTitle.textColor = [UIColor colorWithWhite:1.-alpha
                                                   alpha:1.];
    self.nextButton.tintColor = navBarElementsColor;
    self.closeButton.tintColor = navBarElementsColor;
}

static CGFloat headerHeight = 80.;

- (void)layout
{
    self.header = [self buildHeader];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, headerHeight)];
    [header addSubview:self.header];
    self.tableView.tableHeaderView = header;
    [UIView autoSetIdentifier:@"Clubs Headers Pins to superview" forConstraints:^{
        [self.header autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.header autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.header autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.header autoSetDimension:ALDimensionWidth toSize:self.view.width];
    }];
    self.navigationBarAnimationBG = [[UIView alloc] initForAutoLayout];
    [self.view addSubview:self.navigationBarAnimationBG];
    self.navBarTitle = [[UILabel alloc] initForAutoLayout];
    [self.view addSubview:self.navBarTitle];
    self.navBarTitle.font = [UIFont helveticaNeue:SFFontStyleMedium size:16.0];
    self.navBarTitle.textColor = [UIColor whiteColor];
    [self.navBarTitle autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.navigationBarAnimationBG
                         withOffset:10];
    [self.navBarTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.navigationBarAnimationBG autoSetDimension:ALDimensionHeight
                                             toSize:64];
    [self.navigationBarAnimationBG autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                            excludingEdge:ALEdgeBottom];
    [self.navigationBarAnimationBG setBackgroundColor:[UIColor whiteColor]];
    self.navigationBarAnimationBG.alpha = 0;
    [self updateInfo];
}

#pragma mark - KLEnumViewControllerDelegate

- (void)enumViewController:(KLEnumViewController *)controller
            didSelectValue:(KLEnumObject *)value
{
    switch (value.type) {
        case KLEnumTypeEventType:{
            self.eventTypeInput.value = value;
            if (value.iconNameString.length>0) {
                self.eventTypeInput.iconView.image = [UIImage imageNamed:value.iconNameString];
            }
        }break;
        case KLEnumTypePrivacy:
            self.privacyInput.value = value;
            break;
    }
}

#pragma mark - KLLocationSelectTableViewControllerDelegate

- (void)dissmissLocationSelectTableView:(KLLocationSelectTableViewController *)selectViewController
                              withVenue:(KLForsquareVenue *)venue
{
    self.locationInput.value = venue;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - KLPricingDelegate

- (void)dissmissCreateEvent
{
    [self onClose];
}

@end
