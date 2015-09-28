//
//  KLCharge.h
//  Klike
//
//  Created by Alexey on 5/20/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLCharge : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *chargeId;
@property (nonatomic, strong) NSString *paymentId;
@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) KLEvent *event;
@property (nonatomic, strong) KLCard *card;
@property (nonatomic, strong) NSNumber *amount;

@end
