//
//  KLExploreEventCell.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreEventCell.h"
#import "KLForsquareVenue.h"

@implementation KLExploreEventCell

- (void)configureWithEvent:(KLEvent *)event
{
    KLUserWrapper *currentUser = [[KLAccountManager sharedManager] currentUser];
    
    self.titleLabel.text = event.title;
    
//    switch ([event.pricingType integerValue]) {
//        case KLEventPricingTypeFree:{
//            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeFreeColor];
//            [self.priceBadge setTitle:SFLocalized(@"event.badge.free")
//                             forState:UIControlStateNormal];
//        }break;
//        case KLEventPricingTypeThrow:{
//            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgeThrowInColor];
//            [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.throw"), [event.minimumAmount floatValue]]
//                             forState:UIControlStateNormal];
//        }break;
//        case KLEventPricingTypePayed:{
//            self.priceBadge.tintColor = [UIColor colorFromHex:klBadgePayedColor];
//            [self.priceBadge setTitle:[NSString stringWithFormat:SFLocalized(@"event.badge.payed"), [event.pricePerPerson floatValue]]
//                             forState:UIControlStateNormal];
//        }break;
//        default:
//            break;
//    }
    
    self.backImage.image = nil;
    self.backImage.file = event.backImage;
    [self.backImage loadInBackground];
    
    NSString *startDateStr = [event.startDate mt_stringFromDateWithFormat:@"MMM d"
                                                                localized:NO];
//    if (event.location) {
//        KLForsquareVenue *userVenue = [[KLForsquareVenue alloc] initWithObject:currentUser.place];
//        KLForsquareVenue *eventVenue = [[KLForsquareVenue alloc] initWithObject:event.location];
//        CLLocationDistance distance = [userVenue distanceTo:eventVenue];
//        NSString *milesString = [NSString stringWithFormat:SFLocalized(@"event.location.distance"), distance*0.000621371];//Convert to miles
//        NSString *detailsStr = [NSString stringWithFormat:@"%@, %@ - %@", startDateStr, milesString, eventVenue.name];
//        self.detailsLabel.text = detailsStr;
//    } else {
        self.detailsLabel.text = startDateStr;
//    }
    
    KLEnumObject *eventTypObject = [[KLEventManager sharedManager] eventTypeObjectWithId:[event.eventType integerValue]];
    self.typeIcon.image = [UIImage imageNamed:eventTypObject.iconNameString];
    self.typeLabel.text = eventTypObject.descriptionString;
    
    if (event.dresscode) {
        self.slashImageView.hidden = NO;
        self.dressCodeLabel.hidden = YES;
        self.dressCodeLabel.text = event.dresscode;
    } else {
        self.slashImageView.hidden = YES;
        self.dressCodeLabel.hidden = YES;
    }
}

@end
