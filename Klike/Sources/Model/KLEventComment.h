//
//  KLEventComment.h
//  Klike
//
//  Created by Alexey on 5/11/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLEventComment : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *owner;
@property (nonatomic, strong) NSString *text;

@end
