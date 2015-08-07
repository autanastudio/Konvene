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
#import "KLLocation.h"
#import "KLEnumViewController.h"
#import "KLActivityIndicator.h"
#import "KLPricingFormCell.h"
#import "AppDelegate.h"
#import "KLInviteFriendsViewController.h"



@interface KLCreateEventViewController () <KLEnumViewControllerDelegate, KLLocationSelectTableViewControllerDelegate, KLPricingDelegate, KLFormCellDelegate, SFFormDataSourceDelegate> {
    BOOL _hasChanges;
}

@property (nonatomic, strong) KLCreateEventHeaderView *header;

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

@property (nonatomic, strong) KLPricingFormCell *pricingCell;

//Data
@property (nonatomic, strong) KLEvent *event;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, assign) KLCreateEventViewControllerType type;

@end

@implementation KLCreateEventViewController

@dynamic header;

- (instancetype)initWithType:(KLCreateEventViewControllerType)type
                       event:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.type = type;
        self.event = event;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithType:KLCreateEventViewControllerTypeCreate
                        event:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _hasChanges = NO;
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
    
    UIImage *nextButtonImage;
    if (self.type == KLCreateEventViewControllerTypeCreate) {
        nextButtonImage = [UIImage imageNamed:@"event_right_arr_whight"];
    } else {
        nextButtonImage = [UIImage imageNamed:@"tick"];
    }
    self.nextButton = [[UIBarButtonItem alloc] initWithImage:nextButtonImage
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
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(64., 0.0, (keyboardSize.height)+20., 0.0);
        
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
    
    
    if (self.type == KLCreateEventViewControllerTypeEdit) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 72)];
        footerView.backgroundColor = [UIColor clearColor];
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton autoSetDimension:ALDimensionWidth toSize:100];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_big_stroke"]
                                forState:UIControlStateNormal];
        [deleteButton setTitle:@"Delete"
                      forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor colorFromHex:0x6568c6]
                           forState:UIControlStateNormal];
        [footerView addSubview:deleteButton];
        [deleteButton addTarget:self
                         action:@selector(onDeleteButton)
               forControlEvents:UIControlEventTouchUpInside];
        [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop
                                       withInset:20];
        [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                       withInset:20];
        [deleteButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        self.tableView.tableFooterView = footerView;
        
        if (self.event.backImage) {
            [self.header setLoadableBackImage:self.event.backImage];
            [self updateInfo];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

- (KLCreateEventHeaderView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"CreateEventHeader" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)updateInfo
{
    [super updateInfo];
    if (self.type == KLCreateEventViewControllerTypeEdit) {
        self.navBarTitle.text = @"EDIT EVENT";
    } else {
        self.navBarTitle.text = @"NEW EVENT";
    }
}

- (SFDataSource *)buildDataSource
{
    SFComposedDataSource *form = [[SFComposedDataSource alloc] init];
    
    KLFormDataSource *nameAndDescription = [[KLFormDataSource alloc] init];
    nameAndDescription.delegate = self;
    
    self.nameInput = [[KLBasicFormCell alloc] initWithName:@"Name"
                                               placeholder:@"Name"
                                                     image:[UIImage imageNamed:@"event_name_x1"]];
    self.nameInput.minimumHeight = 64.;
    self.nameInput.iconInsets = UIEdgeInsetsMake(23., 16., 0, 0);
    self.descriptionInput = [[KLMultiLineTexteditForm alloc] initWithName:@"Description"
                                                              placeholder:@"Description (optional)"
                                                                    image:[UIImage imageNamed:@"event_desc_x1"]];
    self.descriptionInput.minimumHeight = 60.;
    self.descriptionInput.iconInsets = UIEdgeInsetsMake(23., 16., 0, 0);
    
    [nameAndDescription addFormInput:self.nameInput];
    [nameAndDescription addFormInput:self.descriptionInput];
    
    self.dateAndLocationForm = [[KLFormDataSource alloc] init];
    
    self.startDateInput = [[KLDateCell alloc] initWithName:@"Start"
                                                     image:[UIImage imageNamed:@"event_start"]
                                                     title:@"Start"
                                                     value:[NSDate date]];
    __weak typeof(self) weakSelf = self;
    [self.startDateInput sf_addObserverForKeyPath:@"value"
                                        withBlock:^(id obj, NSDictionary *change, id observer) {
                                            _hasChanges = YES;
                                            weakSelf.endDateInput.minimalDate = weakSelf.startDateInput.value;
    }];
    self.startDateInput.iconInsets = UIEdgeInsetsMake(16., 16., 0, 0);
    self.startDatePicker = [[KLTimePickerCell alloc] init];
    self.startDatePicker.delegate = self.startDateInput;
    self.endDateInput = [[KLDateCell alloc] initWithName:@"End"
                                                   image:[UIImage imageNamed:@"event_end"]
                                                   title:@"End (optional)"
                                                   value:nil];
    self.endDateInput.iconInsets = UIEdgeInsetsMake(15., 16., 0, 0);
    self.endDateInput.showDeleteValueButton = YES;
    self.endDateInput.showShortDate = YES;
    self.endDateInput.minimalDate = [NSDate date];
    self.endDatePicker = [[KLTimePickerCell alloc] init];
    self.endDatePicker.delegate = self.endDateInput;
    self.locationInput = [[KLSettingCell alloc] initWithName:@"Location"
                                                       image:[UIImage imageNamed:@"event_pin"]
                                                       title:@"Location"
                                                       value:nil];
    self.locationInput.iconInsets = UIEdgeInsetsMake(12., 16., 0, 0);
    self.locationInput.minimumHeight = 44;
    
    [self.dateAndLocationForm addFormInput:self.startDateInput];
    [self.dateAndLocationForm addFormInput:self.endDateInput];
    [self.dateAndLocationForm addFormInput:self.locationInput];
    
    KLFormDataSource *privacy = [[KLFormDataSource alloc] init];
    privacy.delegate  = self;
    
    KLEnumObject *defaultPrivacy = [[KLEventManager sharedManager] privacyTypeEnumObjects][0];
    self.privacyInput = [[KLDescriptionCell alloc] initWithName:@"Privacy"
                                                          image:[UIImage imageNamed:@"event_public"]
                                                          title:@"Privacy"
                                                          value:defaultPrivacy];
    self.privacyInput.iconInsets = UIEdgeInsetsMake(15., 16., 0, 0);
    
    [privacy addFormInput:self.privacyInput];
    
    KLFormDataSource *details = [[KLFormDataSource alloc] init];
    details.delegate = self;
    
    self.eventTypeInput = [[KLSettingCell alloc] initWithName:@"type"
                                                        image:[UIImage imageNamed:@"ic_event_type_01"]
                                                        title:@"Event Type (optional)"
                                                        value:nil];
    self.eventTypeInput.iconInsets = UIEdgeInsetsMake(8., 11., 0, 0);
    self.eventTypeInput.useCranch = YES;
    self.eventTypeInput.minimumHeight = 48.;
    self.dresscodeInput = [[KLBasicFormCell alloc] initWithName:@"dresscode"
                                                    placeholder:@"Dresscode (optional)"
                                                          image:[UIImage imageNamed:@"event_dress"]
                                                          value:nil];
    self.dresscodeInput.iconInsets = UIEdgeInsetsMake(14., 16., 0, 0);
    self.dresscodeInput.minimumHeight = 43;
    self.dresscodeInput.textField.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                          size:14.];
    
    [details addFormInput:self.eventTypeInput];
    [details addFormInput:self.dresscodeInput];
    
    [form addDataSource:nameAndDescription];
    [form addDataSource:self.dateAndLocationForm];
    [form addDataSource:privacy];
    [form addDataSource:details];
    
    if (self.type == KLCreateEventViewControllerTypeEdit) {
        KLFormDataSource *pricing = [[KLFormDataSource alloc] init];
        
        self.pricingCell = [[KLPricingFormCell alloc] initWithName:@"pricing"
                                                             value:self.event.price];
        [self.pricingCell layoutIfNeeded];
        [pricing addFormInput:self.pricingCell];
        [form addDataSource:pricing];
        [self fillDataSourceWithEvent];
    }
    
    return form;
}

- (void)fillEventWithData
{
    if (!self.event) {
        self.event = [KLEvent object];
        self.event.owner = [KLAccountManager sharedManager].currentUser.userObject;
    }
    if (self.type == KLCreateEventViewControllerTypeEdit) {
        self.event.price = self.pricingCell.value;
    }
    if (![self.event.title isEqualToString:self.nameInput.value]) {
        [self.event kl_setObject:self.nameInput.value
                          forKey:sf_key(title)];
    }
    [self.event kl_setObject:self.descriptionInput.value
                      forKey:sf_key(descriptionText)];
    if (![self.event.startDate isEqualToDate:self.startDateInput.value]) {
        [self.event kl_setObject:self.startDateInput.value
                          forKey:sf_key(startDate)];
    }
    if (self.endDateInput.value) {
        [self.event kl_setObject:self.endDateInput.value
                          forKey:sf_key(endDate)];
    } else {
        [self.event kl_setObject:[self.event.startDate mt_dateHoursAfter:12]
                          forKey:sf_key(endDate)];
    }
    
    KLLocation *venue = self.locationInput.value;
    if (venue) {
        if (![self.event.location isEqual:venue.locationObject]) {
            [self.event kl_setObject:venue.locationObject
                              forKey:sf_key(location)];
            self.event.point = [PFGeoPoint geoPointWithLocation:venue.location];
        }
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
}

- (void)fillDataSourceWithEvent
{
    if (self.type == KLCreateEventViewControllerTypeEdit) {
        self.nameInput.value = self.event.title;
        self.descriptionInput.value = self.event.descriptionText;
        self.startDateInput.value = self.event.startDate;
        if (self.event.endDate) {
            self.endDateInput.value = self.event.endDate;
        }
        KLLocation *venue = [[KLLocation alloc] initWithObject:self.event.location];
        self.locationInput.value = venue;
        
        
        KLEnumObject *privacyObject = [KLEventManager sharedManager].privacyTypeEnumObjects[[self.event.privacy integerValue]];
        self.privacyInput.value = privacyObject;
        KLEnumObject *typeObject = [[KLEventManager sharedManager] eventTypeObjectWithId:[self.event.eventType integerValue]];
        self.eventTypeInput.value = typeObject;

        self.dresscodeInput.value = self.event.dresscode;
    }
}

#pragma mark - Actions

- (void)onDeleteButton
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Do you really want to delete this event?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    view.tag = 1;
    [view show];
    
    
}

- (void)onClose
{
    if (!_hasChanges) {
        [self.delegate dissmissCreateEventViewController:self
                                                newEvent:self.event];
        return;
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SFLocalized(@"Discard all changes?")
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* unfollowAction = [UIAlertAction actionWithTitle:@"YES"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [self.delegate dissmissCreateEventViewController:self
                                                                                                           newEvent:self.event];
                                                               }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:unfollowAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

- (void)onNext
{
    NSArray *requiredField = @[self.nameInput, self. startDateInput, self.locationInput];
    for (KLFormCell *input in requiredField) {
        if (![input hasValue]) {
            [self showNavbarwithErrorMessage:[NSString stringWithFormat:SFLocalized(@"event.create.error.fill.message"), input.name]];
            return;
        }
    }
    [self fillEventWithData];
    
    if (self.type == KLCreateEventViewControllerTypeCreate) {
        KLPricingController *priceController = [[KLPricingController alloc] initWithEvent:self.event];
        priceController.delegate = self;
        [self.navigationController pushViewController:priceController
                                             animated:YES];
    }
    else {
        __weak typeof(self) weakSelf = self;
        
        NSMutableArray *activities = [NSMutableArray array];
        if ([self.event isDirtyForKey:sf_key(title)]) {
            [activities addObject:[self createActivityForType:KLActivityTypeEventChangedName]];
        }
        if ([self.event isDirtyForKey:sf_key(location)]) {
            [activities addObject:[self createActivityForType:KLActivityTypeEventChangedLocation]];
        }
        if ([self.event isDirtyForKey:sf_key(startDate)]) {
            [activities addObject:[self createActivityForType:KLActivityTypeEventChangedTime]];
        }
        
        [[KLEventManager sharedManager] uploadEvent:self.event toServer:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                for (KLActivity *activity in activities) {
                    [activity saveInBackground];
                }
                [weakSelf.delegate dissmissCreateEventViewController:weakSelf
                                                            newEvent:weakSelf.event];
                
            }
        }];
    }
}

- (KLActivity *)createActivityForType:(KLActivityType)type
{
    KLActivity *newActivity = [KLActivity object];
    newActivity.activityType = @(type);
    newActivity.from = [KLAccountManager sharedManager].currentUser.userObject;
    newActivity.observers = [self.event.savers arrayByAddingObjectsFromArray:self.event.attendees];
    newActivity.event = self.event;
    return newActivity;
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
    [self updateInfo];
    _hasChanges = YES;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *firstresponderTemp = [self findFirstResponderInView:self.view];
    if (cell == self.startDateInput) {
        if (firstresponderTemp) {
            [firstresponderTemp resignFirstResponder];
        }
        [self tooggleDateCell:self.startDatePicker];
        return;
    } else if ( cell == self.endDateInput) {
        if (firstresponderTemp) {
            [firstresponderTemp resignFirstResponder];
        }
        [self.endDatePicker setMinimalDate:self.startDateInput.value];
        if (self.endDateInput.value) {
            self.endDatePicker.date = self.endDateInput.value;
        }
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
        KLLocationSelectTableViewController *location = [[KLLocationSelectTableViewController alloc] initWithType:KLLocationSelectTypeGooglePlaces];
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

- (UIView *)findFirstResponderInView:(UIView *)view
{
    if ([view isFirstResponder]) {
        return view;
    } else if(view.subviews && view.subviews.count){
        for (UIView *subview in view.subviews) {
            UIView *temp = [self findFirstResponderInView:subview];
            if (temp) {
                return temp;
            }
        }
    }
    return nil;
}

#pragma mark - Scroll

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    UIColor *navBarElementsColor = [UIColor colorWithRed:1.-(1.-100./255.)*alpha
                                                   green:1.-(1.-102./255.)*alpha
                                                    blue:1.-(1.-202./255.)*alpha
                                                   alpha:1.];
    self.navBarTitle.textColor = [UIColor colorWithWhite:1.-alpha
                                                   alpha:1.];
    self.nextButton.tintColor = navBarElementsColor;
    self.closeButton.tintColor = navBarElementsColor;
}

#pragma mark - KLEnumViewControllerDelegate

- (void)enumViewController:(KLEnumViewController *)controller
            didSelectValue:(KLEnumObject *)value
{
    _hasChanges = YES;
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
    _hasChanges = YES;
    self.locationInput.value = venue;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - KLPricingDelegate

- (void)dissmissCreateEvent
{
    [self.delegate dissmissCreateEventViewController:self
                                            newEvent:self.event];
}

#pragma mark - SFFormDataSourceDelegate

- (void)valueHasChenges:(KLFormDataSource *)dataSource
{
    _hasChanges = YES;
}

@end
