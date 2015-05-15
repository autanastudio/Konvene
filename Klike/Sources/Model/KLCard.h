//
//  KLCard.h
//  Klike
//
//  Created by Alexey on 5/15/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLCard : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *last4;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *expMonth;
@property (nonatomic, strong) NSString *expYear;

@end
