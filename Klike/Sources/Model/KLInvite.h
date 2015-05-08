//
//  KLInvite.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLInvite : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) KLEvent *event;
@property (nonatomic, strong) PFUser *user;

@end
