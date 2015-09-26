//
//  KLEventPrice.h
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

typedef enum : NSUInteger {
    KLEventPricingTypeFree,
    KLEventPricingTypePayed,
    KLEventPricingTypeThrow,
} KLEventPricingType;

@interface KLEventPrice : PFObject <PFSubclassing>

@property(nonatomic, strong) NSNumber *pricingType;

@property(nonatomic, strong) NSNumber *pricePerPerson;
@property(nonatomic, strong) NSNumber *maximumTickets;
@property(nonatomic, strong) NSNumber *soldTickets;

@property(nonatomic, strong) NSNumber *minimumAmount;
@property(nonatomic, strong) NSNumber *suggestedAmount;
@property(nonatomic, strong) NSNumber *throwIn;

@property(nonatomic, strong) NSString *stripeId;
@property(nonatomic, strong) KLVenmoInfo *venmoInfo;

@property(nonatomic, strong) NSArray *payments;

@property(nonatomic, readonly) CGFloat youGet;

@end
