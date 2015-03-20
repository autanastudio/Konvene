//
//  KLAddressBookHelper.h
//  Klike
//
//  Created by Dima on 20.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAddressBookHelper : NSObject
- (void)authorizeWithCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)guessUserPhoneForFirstName:(NSString *)first
                          lastName:(NSString *)last
                        completion:(void (^)(NSString *phone))phone;
- (void)loadListOfContacts:(void (^)(NSArray *rawContants))completionHandler;
- (NSArray *)sortedContactsList:(NSArray *)array;
- (BOOL)isAuthorized;
@end
