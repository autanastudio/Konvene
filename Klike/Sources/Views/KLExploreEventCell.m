//
//  KLExploreEventCell.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventCell.h"
#import "KLForsquareVenue.h"

static NSInteger klBadgeFreeColor = 0x00c29b;
static NSInteger klBadgeThrowInColor = 0x0494b3;
static NSInteger klBadgePayedColor = 0x346bbd;

@implementation KLExploreEventCell

- (void)configureWithEvent:(KLEvent *)event
{
    KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
    
    self.titleLabel.text = event.title;
    
    switch ([event.pricingType integerValue]) {
        case KLEventPricingTypeFree:{
            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeFreeColor];
            [self.priceBadge setTitle:SFLocalized(@"event.badge.free")
                             forState:UIControlStateNormal];
        }break;
        case KLEventPricingTypeThrow:{
            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeThrowInColor];
            [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.throw"), [event.minimumAmount floatValue]]
                             forState:UIControlStateNormal];
        }break;
        case KLEventPricingTypePayed:{
            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgePayedColor];
            [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.payed"), [event.pricePerPerson floatValue]]
                             forState:UIControlStateNormal];
        }break;
        default:
            break;
    }
    
    self.backImage.image = [UIImage imageNamed:@"event_pic_placeholder"];
    self.backImage.file = event.backImage;
    [self.backImage loadInBackground];
    
    NSString *startDateStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                localized:NO];
    if (event.location) {
        KLForsquareVenue *eventVenue = [[KLForsquareVenue alloc] initWithObject:event.location];
        PFObject *userPlace = currentUser.place;
        if (userPlace.isDataAvailable) {
            KLForsquareVenue *userVenue = [[KLForsquareVenue alloc] initWithObject:currentUser.place];
            CLLocationDistance distance = [userVenue distanceTo:eventVenue];
            NSString *milesString = [NSString stringWithFormat:SFLocalized(@"event.location.distance"), distance*0.000621371];//Convert to miles
            startDateStr = [NSString stringWithFormat:@"%@, %@", startDateStr, milesString];
        }
        NSString *detailsStr = [NSString stringWithFormat:@"%@ - %@", startDateStr, eventVenue.name];
        self.detailsLabel.text = detailsStr;
    } else {
        self.detailsLabel.text = startDateStr;
    }
    
    KLEnumObject *eventTypeObject = [[KLEventManager sharedManager] eventTypeObjectWithId:[event.eventType integerValue]];
    if (eventTypeObject && eventTypeObject.enumId!=0) {
        self.typeIcon.hidden = NO;
        self.typeLabel.hidden = NO;
        self.slashImageView.hidden = NO;
        self.typeIcon.image = [UIImage imageNamed:eventTypeObject.iconNameString];
        self.typeLabel.text = eventTypeObject.descriptionString;
    } else {
        self.typeIcon.hidden = YES;
        self.typeLabel.hidden = YES;
        self.slashImageView.hidden = YES;
    }    
    if (event.dresscode && event.dresscode.length) {
        self.slashImageView.hidden = NO;
        self.dressCodeLabel.hidden = YES;
        self.dressCodeLabel.text = event.dresscode;
    } else {
        self.slashImageView.hidden = YES;
        self.dressCodeLabel.hidden = YES;
    }
    [self layoutIfNeeded];
}

- (void)updateLocationInfo
{
    
}

@end
