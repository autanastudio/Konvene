//
//  KLVenmoInfo.h
//  Klike
//
//  Created by Nick O'Neill on 9/21/15.
//  Copyright © 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLVenmoInfo : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;

+ (KLVenmoInfo *)venmoInfoWithoutDataWithId:(NSString *)objectId;

@end
