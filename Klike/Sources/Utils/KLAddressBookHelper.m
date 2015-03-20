//
//  KLAddressBookHelper.m
//  Klike
//
//  Created by Dima on 20.03.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAddressBookHelper.h"
#import "PFUser.h"
static NSString *klUserKeyPk = @"userPk";
static NSString *klUserKeyBackImage = @"userBackImage";
static NSString *klUserKeyisRegistered = @"isRegistered";
static NSString *klUserKeyFullName = @"fullName";
static NSString *klUserKeyFirstName = @"firstName";
static NSString *klUserKeyLastName = @"lastName";
static NSString *klUserKeyEmails = @"emails";
static NSString *klUserKeyPhone = @"phone";

@import AddressBook;

@interface KLAddressBookHelper () {
    ABAddressBookRef       _addressBook;
}
@end

@implementation KLAddressBookHelper


void AddressBookDidChangeCallBack(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    NSLog(@"AddressBook Did Change: %@", (__bridge NSDictionary *)info);
};

- (instancetype)init {
    self = [super init];
    if (self) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}

- (BOOL)isAuthorized {
    return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
}

- (void)authorizeWithCompletionHandler:(void (^)(BOOL))completionHandler {
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ABAddressBookRegisterExternalChangeCallback(_addressBook, AddressBookDidChangeCallBack, NULL);
            completionHandler(granted);
        });
    });
}

- (void)loadListOfContacts:(void (^)(NSArray *))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *allContacts = nil;
        NSPredicate *predicate;
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        if (people != NULL) {
            CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                                       kCFAllocatorDefault,
                                                                       CFArrayGetCount(people),
                                                                       people
                                                                       );
            
            
            CFArraySortValues(
                              peopleMutable,
                              CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                              (CFComparatorFunction) ABPersonComparePeopleByName,
                              (void *) ABPersonGetSortOrdering()
                              );
            
            CFRelease(people);
            allContacts = CFBridgingRelease(peopleMutable);
            predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary* bindings) {
                ABMultiValueRef phoneNumbers = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonPhoneProperty);
                ABMultiValueRef emails = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonEmailProperty);
                BOOL result = (ABMultiValueGetCount(phoneNumbers) > 0) || (ABMultiValueGetCount(emails) > 0);
                CFRelease(phoneNumbers);
                CFRelease(emails);
                return result;
            }];
            allContacts = [allContacts filteredArrayUsingPredicate:predicate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *result = [NSMutableArray new];
            
            for (id record  in allContacts) {
                PFUser *user = [PFUser user] ;
                ABRecordRef person = (__bridge ABRecordRef)record;
                user[klUserKeyPk] = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
                user[klUserKeyFullName] = CFBridgingRelease(ABRecordCopyCompositeName(person));
                if ([user[klUserKeyFullName] rangeOfString:@"GroupMe"].length > 0) {
                    continue;
                }
                user[klUserKeyFirstName] = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                user[klUserKeyLastName] = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
                ABMultiValueRef phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonPhoneProperty);
                ABMultiValueRef emailValues = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonEmailProperty);
                
                ABMultiValueRef emailProperty = ABRecordCopyValue(person, kABPersonEmailProperty);
                NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
                if ([emailArray count] > 0) {
                    if ([emailArray count] > 1) {
                        NSMutableArray *emails = [[NSMutableArray alloc] init];
                        user.email = [emailArray firstObject];
                        for (int i = 0; i < [emailArray count]; i++) {
                            [emails addObject:[emailArray objectAtIndex:i]];
                        }
                        user[klUserKeyEmails] = emails;
                    }else {
                        user.email = [emailArray firstObject];
                    }
                }
                
                for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                    NSString *rawPhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
                    
                    if (![user[klUserKeyPhone] notEmpty]) {
                        user[klUserKeyPhone] = [self normalizePhone:KLStringGetByFilteringPhone(rawPhone)];
                    }
                }
                
                CFRelease(phoneNumbers);
                [result addObject:user];
            }
            
            for (id person in allContacts) {
                CFRelease((ABRecordRef)person);
            }
            
            if (completionHandler) {
                completionHandler(result);
            }
        });
        
    });
}

- (NSString *)normalizePhone:(NSString *)phone
{
    phone = KLStringGetByFilteringPhone(phone);
    if ([phone notEmpty]) {
        if (phone.length == 10) {
            phone = [NSString stringWithFormat:@"1%@", phone];
        }
    }
    return phone;
}

NSString * KLStringGetByFilteringPhone(NSString *phone)
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return [[phone componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

@end
