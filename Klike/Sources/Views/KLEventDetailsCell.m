//
//  KLEventDetailsCell.m
//  Klike
//
//  Created by admin on 04/05/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventDetailsCell.h"
#import "KLLocation.h"

static CGFloat klInviteButtonWidth = 55.;

@interface KLEventDetailsCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dressCodeLeftConstraint;

@end

@implementation KLEventDetailsCell


- (void)awakeFromNib
{
    [self.attendies makeObjectsPerformSelector:@selector(kl_fromRectToCircle)];
}

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
    
    self.titleLabel.text = event.title;
    
    if ([event isPastEvent]) {
        self.inviteButtonWidthConstraint.active = YES;
        self.inviteButton.enabled = NO;
        self.detailsLabel.textColor = [UIColor colorFromHex:0xb3b3bd];
    } else {
        self.inviteButtonWidthConstraint.active = NO;
        self.inviteButton.enabled = YES;
        self.detailsLabel.textColor = [UIColor blackColor];
    }
    
    NSString *startDateStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                localized:NO];
    if (event.location && event.location.isDataAvailable) {
        KLLocation *eventVenue = [[KLLocation alloc] initWithObject:event.location];
        PFObject *userPlace = currentUser.place;
        if (userPlace.isDataAvailable) {
            KLLocation *userVenue = [[KLLocation alloc] initWithObject:currentUser.place];
            CLLocationDistance distance = [userVenue distanceTo:eventVenue];
            NSString *milesString = [NSString stringWithFormat:SFLocalized(@"event.location.distance"), distance*0.000621371];//Convert to miles
            startDateStr = [NSString stringWithFormat:@"%@, %@", startDateStr, milesString];
        }
        NSString *detailsStr = [NSString stringWithFormat:@"%@ \U00002014 %@", startDateStr, eventVenue.name];
        [self.detailsLabel setText:detailsStr
             withMinimumLineHeight:16.
                     strikethrough:[event isPastEvent]];
    } else {
        [self.detailsLabel setText:startDateStr
             withMinimumLineHeight:16.
                     strikethrough:[event isPastEvent]];
    }
    
    KLEnumObject *privacyObject = [KLEventManager sharedManager].privacyTypeEnumObjects[[event.privacy integerValue]];
    if ([event isOwner:currentUser]) {
        self.privateIcon.hidden = NO;
        self.privateLabel.hidden = NO;
        self.reportButton.hidden = YES;
        self.privateIcon.image = [UIImage imageNamed:privacyObject.iconNameString];
        self.privateLabel.text = privacyObject.descriptionString;
        self.inviteButton.enabled = YES;
    } else {
        self.privateIcon.hidden = YES;
        self.privateLabel.hidden = YES;
        self.reportButton.hidden = NO;
        BOOL isPublic = privacyObject.enumId == KLEventPrivacyTypePublic;
        BOOL isPrivatePlus = (privacyObject.enumId == KLEventPrivacyTypePrivatePlus) &&
        ([event.invited indexOfObject:currentUser.userObject.objectId]!=NSNotFound);
        self.inviteButton.enabled = isPublic || isPrivatePlus;
    }
    
    KLEnumObject *eventTypeObject = [[KLEventManager sharedManager] eventTypeObjectWithId:[event.eventType integerValue]];
    self.slashImageView.hidden = NO;
    if (eventTypeObject && eventTypeObject.enumId!=0) {
        self.typeIcon.hidden = NO;
        self.typeLabel.hidden = NO;
        self.slashImageView.hidden = NO;
        self.typeIcon.image = [UIImage imageNamed:eventTypeObject.iconNameString];
        self.typeLabel.text = eventTypeObject.descriptionString;
        self.dressCodeLeftConstraint.active = NO;
    } else {
        self.typeIcon.hidden = YES;
        self.typeLabel.hidden = YES;
        self.slashImageView.hidden = YES;
        self.dressCodeLeftConstraint.active = YES;
        self.slashImageView.hidden = YES;
    }
    if (event.dresscode && event.dresscode.length) {
        self.dressCodeLabel.hidden = NO;
        self.dressCodeLabel.text = event.dresscode;
    } else {
        self.slashImageView.hidden = YES;
        self.dressCodeLabel.hidden = YES;
    }
    [self layoutIfNeeded];
    
    self.attendiesCountLabel.text = [NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
                                     [NSString abbreviateNumber:event.attendees.count]];
    NSInteger limit = MIN(event.attendees.count, 5);
    self.attendiesButton.enabled = limit>0;
    if (limit<4) {
        self.attendiesCountLabel.hidden = YES;
    } else {
        self.attendiesCountLabel.hidden = NO;
        self.attendiesCountLabel.text = [NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
                                         [NSString abbreviateNumber:event.attendees.count]];
    }
    
    for (PFImageView *imageView in self.attendies) {
        if (imageView.tag<limit) {
            imageView.hidden = NO;
        } else {
            imageView.hidden = YES;
        }
    }
    if (limit) {
        __weak typeof(self) weakSelf = self;
        [[KLEventManager sharedManager] attendiesForEvent:event
                                                    limit:limit
                                             completition:^(NSArray *objects, NSError *error) {
                                                 for (PFImageView *imageView in weakSelf.attendies) {
                                                     if (imageView.tag<limit) {
                                                         KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:objects[imageView.tag]];
                                                         imageView.file = user.userImage;
                                                         [imageView loadInBackground];
                                                     }
                                                 }
                                             }];
    }
}

- (IBAction)onReport:(id)sender {
    if ([self.delegate respondsToSelector:@selector(detailsCellDidPressReport)]) {
        [self.delegate performSelector:@selector(detailsCellDidPressReport)
                            withObject:nil];
    }
}

- (void)startAppearAnimation
{
    
}

@end
