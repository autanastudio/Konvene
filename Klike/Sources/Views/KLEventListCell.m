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

@implementation KLEventListCell

- (void)configureWithEvent:(KLEvent *)event
{
    KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
    
    self.titileLabel.text = event.title;
    
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
    
    self.backImageView.image = nil;
    self.backImageView.file = event.backImage;
    [self.backImageView loadInBackground];
    
    NSString *startDateStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                localized:NO];
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
        self.detailsLabel.text = detailsStr;
    } else {
        self.detailsLabel.text = startDateStr;
    }
    [self layoutIfNeeded];
}

@end
