//
//  NSString+SF_Additions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "NSString+SF_Additions.h"
#import "NSDictionary+SF_Additions.h"

@implementation NSString (SF_Additions)

- (double)numberValue {
    return [[[self componentsSeparatedByCharactersInSet:
              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:[NSString string]] doubleValue];
}

- (unsigned long long)unsignedLongLongValue
{
    return (unsigned long long)[self longLongValue];
}

- (NSString *)digitString {
    NSMutableString *string = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [string appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return string;
}

- (BOOL)notEmpty {
    return [self length] != 0;
}

- (NSString *)snakecaseString {
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (BOOL)isEqualToPhone:(NSString *)phone {
    
    NSString *firstPhone = self;
    NSString *secondPhone = phone;
    
    firstPhone = [firstPhone digitString];
    secondPhone = [secondPhone digitString];
    
    if (firstPhone.length < 10 || secondPhone.length < 10) {
        return NO;
    }
    
    firstPhone = [firstPhone substringFromIndex:firstPhone.length - 10];
    secondPhone = [secondPhone substringFromIndex:secondPhone.length - 10];
    
    return [firstPhone isEqualToString:secondPhone];
}

- (NSDictionary *)queryParameters
{
    return [self queryParametersUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)queryParametersUsingEncoding:(NSStringEncoding)encoding
{
    return [self queryParametersUsingArrays:NO encoding:encoding];
}

// TODO: Eliminate...
- (NSDictionary *)queryParametersUsingArrays:(BOOL)shouldUseArrays encoding:(NSStringEncoding)encoding
{
    NSString *stringToParse = self;
    NSRange chopRange = [stringToParse rangeOfString:@"?"];
    if (chopRange.length > 0) {
        chopRange.location += 1; // we want inclusive chopping up *through *"?"
        if (chopRange.location < [stringToParse length])
            stringToParse = [stringToParse substringFromIndex:chopRange.location];
    }
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringToParse];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        
        if (!shouldUseArrays) {
            if (kvPair.count == 2) {
                NSString *key = [[kvPair objectAtIndex:0]
                                 stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSString *value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [pairs setObject:value forKey:key];
            }
        }
        else {
            if (kvPair.count == 1 || kvPair.count == 2) {
                NSString *key = [[kvPair objectAtIndex:0]
                                 stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSMutableArray *values = [pairs objectForKey:key];
                if (nil == values) {
                    values = [NSMutableArray array];
                    [pairs setObject:values forKey:key];
                }
                if (kvPair.count == 1) {
                    [values addObject:[NSNull null]];
                    
                } else if (kvPair.count == 2) {
                    NSString *value = [[kvPair objectAtIndex:1]
                                       stringByReplacingPercentEscapesUsingEncoding:encoding];
                    [values addObject:value];
                }
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}


- (NSString *)stringByAddingURLEncoding
{
    CFStringRef legalURLCharactersToBeEscaped = CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`\n\r");
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        legalURLCharactersToBeEscaped,
                                                                        kCFStringEncodingUTF8);
    if (encodedString) {
        return CFBridgingRelease(encodedString);
    }
    
    // TODO: Log a warning?
    return @"";
}

- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)queryParameters
{
    if ([queryParameters count] > 0) {
        return [NSString stringWithFormat:@"%@?%@", self, [queryParameters stringWithURLEncodedEntries]];
    }
    return [NSString stringWithString:self];
}

- (NSString *)stringByAddingQueryParameters:(NSDictionary *)queryParameters {
    if ([queryParameters count] > 0) {
        return [NSString stringWithFormat:@"%@&%@", self, [queryParameters stringWithURLEncodedEntries]];
    }
    return [NSString stringWithString:self];
}

- (BOOL)isValidEmail {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidUsername {
    NSString *nickValidationRegexp = @"^[A-Za-z0-9]+(?:[-][A-Za-z0-9]+)*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickValidationRegexp];
    return [test evaluateWithObject:self];
}

- (NSString *)stringFromStrings:(NSString *)string, ... {
    va_list args;
    va_start(args, string);
    
    NSMutableArray *array = [NSMutableArray array];
    id next;
    while ((next = va_arg(args, id))) {
        [array addObject:next];
    }
    
    NSString *str = [array componentsJoinedByString:@" "];
    
    va_end(args);
    
    return str;
}

- (NSString *)firstName
{
    NSArray *nameComponents = [self componentsSeparatedByString:@" "];
    return nameComponents.firstObject;
}

- (NSString *)lastName
{
    NSMutableArray *nameComponents = [self componentsSeparatedByString:@" "].mutableCopy;
    if (nameComponents.count > 1) {
        [nameComponents removeObjectAtIndex:0];
        return [nameComponents componentsJoinedByString:@" "];
    }
    return nil;
}

- (NSString *)removeNulls {
    return [[[self stringByReplacingOccurrencesOfString:@"(null)" withString:@""] stringByReplacingOccurrencesOfString:@"  " withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

