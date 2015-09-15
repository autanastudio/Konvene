//
//  NSDictionary+SF_Additions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "NSDictionary+SF_Additions.h"
#import "NSString+SF_Additions.h"

@implementation NSDictionary (SF_Additions)

- (NSDictionary *)sf_dictionaryWithKeys:(NSArray *)keys
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        [dict sf_setObject:self[key] forKey:key];
    }
    return dict;
}

- (void)URLEncodePart:(NSMutableArray *)parts path:(NSString *)path value:(id)value
{
    NSString *encodedPart = [[value description] stringByAddingURLEncoding];
    [parts addObject:[NSString stringWithFormat:@"%@=%@", path, encodedPart]];
}

- (void)URLEncodeParts:(NSMutableArray *)parts path:(NSString *)inPath
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *encodedKey = [[key description] stringByAddingURLEncoding];
        NSString *path = inPath ? [inPath stringByAppendingFormat:@"[%@]", encodedKey] : encodedKey;
        
        if ([value isKindOfClass:[NSArray class]]) {
            for (id item in value) {
                if ([item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSMutableDictionary class]]) {
                    [item URLEncodeParts:parts path:[path stringByAppendingString:@"[]"]];
                } else {
                    [self URLEncodePart:parts path:[path stringByAppendingString:@"[]"] value:item];
                }
                
            }
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) {
            [value URLEncodeParts:parts path:path];
        }
        else {
            [self URLEncodePart:parts path:path value:value];
        }
    }];
}

- (NSString *)stringWithURLEncodedEntries
{
    NSMutableArray *parts = [NSMutableArray array];
    [self URLEncodeParts:parts path:nil];
    return [parts componentsJoinedByString:@"&"];
}

@end

@implementation NSMutableDictionary (SF_Additions)

- (void)sf_setObject:(id)object forKey:(id)key {
    if (object && key) {
        if ([object isKindOfClass:[NSString class]]) {
            if (![(NSString *)object notEmpty]) {
                return;
            }
        }
        self[key] = object;
    }
}


@end