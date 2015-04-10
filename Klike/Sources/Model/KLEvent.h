//
//  KLEvent.h
//  Klike
//
//  Created by admin on 10/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

typedef enum : NSUInteger {
    KLEventPricingTypeFree,
    KLEventPricingTypePayed,
    KLEventPricingTypeThrow,
} KLEventPricingType;

@interface KLEvent : PFObject <PFSubclassing>

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, strong) KLForsquareVenue *location;
@property(nonatomic, strong) NSNumber *privacy;
@property(nonatomic, strong) NSNumber *eventType;
@property(nonatomic, strong) NSString *dresscode;
@property(nonatomic, strong) PFFile *backImage;
@property(nonatomic, strong) PFUser *owner;

@property(nonatomic, strong) NSNumber *pricingType;
@property(nonatomic, strong) NSNumber *pricePerPerson;
@property(nonatomic, strong) NSNumber *minimumAmount;
@property(nonatomic, strong) NSNumber *suggestedAmount;

+ (NSString *)parseClassName;
- (void)updateEventBackImage:(UIImage *)image;

@end
