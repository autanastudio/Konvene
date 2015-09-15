//
//  NSString+SF_Additions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

///------------------------------------------
/// @name NSString
///------------------------------------------

/**
    Softfacade Additions to NSString class
 */

@interface NSString (SF_Additions)

/**
 Parse string and get number value
 */

- (double)numberValue;

- (unsigned long long)unsignedLongLongValue;

/**
 Return string remove all sumbols but digits.
 */

- (NSString *)digitString;


/**
 
 Check if two phones is equal to each other by the last 10 symbols
 
 @param phone phone to compare
 
 */

- (BOOL)isEqualToPhone:(NSString *)phone;

/**
 */

- (BOOL)notEmpty;

/**
 */

- (NSString *)snakecaseString;

- (NSDictionary *)queryParameters;

- (NSString *)stringByAddingURLEncoding;

- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)queryParameters;

- (NSString *)stringByAddingQueryParameters:(NSDictionary *)queryParameters;

- (BOOL)isValidEmail;

- (BOOL)isValidUsername;

- (NSString *)firstName;

- (NSString *)lastName;

- (NSString *)removeNulls;

@end
