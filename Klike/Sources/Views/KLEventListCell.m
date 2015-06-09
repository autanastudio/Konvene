//
//  KLEventListCell.m
//  Klike
//
//  Created by admin on 17/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventListCell.h"
#import "KLLocation.h"
#import "KLUserWrapper.h"

static NSInteger klBadgeFreeColor = 0x00c29b;
static NSInteger klBadgeThrowInColor = 0x0494b3;
static NSInteger klBadgePayedColor = 0x346bbd;
static NSInteger klBadgeSoldOutColor = 0xc21b4b;

@interface KLEventListCell ()

@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLEventListCell

- (void)awakeFromNib
{
    [self.attendies makeObjectsPerformSelector:@selector(kl_fromRectToCircle)];
}

- (void)configureWithEvent:(KLEvent *)event
{
    self.event = event;
    KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
    
    self.titileLabel.text = event.title;
    
    switch ([event.price.pricingType integerValue]) {
        case KLEventPricingTypeFree:{
            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeFreeColor];
            [self.priceBadge setTitle:SFLocalized(@"event.badge.free")
                             forState:UIControlStateNormal];
        }break;
        case KLEventPricingTypeThrow:{
            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeThrowInColor];
            [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.throw"), [event.price.throwIn floatValue]]
                             forState:UIControlStateNormal];
        }break;
        case KLEventPricingTypePayed:{
            if (event.price.soldTickets==event.price.maximumTickets) {
                self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeSoldOutColor];
                [self.priceBadge setTitle:SFLocalized(@"event.badge.sold_out")
                                 forState:UIControlStateNormal];
            } else {
                self.priceBadge.tintColor = [UIColor colorFromHex:klBadgePayedColor];
                [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.payed"), [event.price.pricePerPerson floatValue]]
                                 forState:UIControlStateNormal];
            }
        }break;
        default:
            break;
    }
    
    self.backImageView.image = nil;
    self.backImageView.file = event.backImage;
    [self.backImageView loadInBackground];
    
    NSString *startDateStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                localized:NO];
    self.detailsLabel.textColor = [event isPastEvent] ? [UIColor colorFromHex:0xb3b3bd] : [UIColor blackColor];
    if (event.location) {
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
             withMinimumLineHeight:24.
                     strikethrough:[event isPastEvent]];
    } else {
        [self.detailsLabel setText:startDateStr
             withMinimumLineHeight:24.
                     strikethrough:[event isPastEvent]];
    }
    [self layoutIfNeeded];
    
    self.attendiesCountLabel.text = [NSString stringWithFormat:SFLocalized(@"explore.event.count.going"),
                                     [NSString abbreviateNumber:event.attendees.count]];
    NSInteger limit = MIN(event.attendees.count, 4);
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
                                                         imageView.file = user.userImageThumbnail;
                                                         [imageView loadInBackground];
                                                     }
                                                 }
                                             }];
    }
}

- (IBAction)onAttendies:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventListCell:showAttendiesForEvent:)]) {
        [self.delegate eventListCell:self
               showAttendiesForEvent:self.event];
    }
}

@end
