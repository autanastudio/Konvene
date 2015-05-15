//
//  KLUserPayment.h
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLUserPayment : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSArray *cards;

@end
