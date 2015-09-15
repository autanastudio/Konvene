//
//  NSDictionary+SF_Additions.h
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

///------------------------------------------
/// @name NSDictionary
///------------------------------------------

@interface NSDictionary (SF_Additions)

- (NSString *)stringWithURLEncodedEntries;

- (NSDictionary *)sf_dictionaryWithKeys:(NSArray *)keys;

@end

/**
 Safe setter methods
 */

@interface NSMutableDictionary (SF_Additions)

/**
 Check for nil object and key before setting
 @param object object
 @param key key
 */

- (void)sf_setObject:(id)object forKey:(id<NSCopying>)key;

@end