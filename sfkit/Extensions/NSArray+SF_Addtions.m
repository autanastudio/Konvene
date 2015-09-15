//
//  NSArray+SF_Addtions.m
//  SFKit
//
//  Created by Yarik Smirnov on 7/19/13.
//  Copyright (c) 2013 Softfacade, LLC. All rights reserved.
//

#import "NSArray+SF_Addtions.h"

@implementation NSArray (SF_Addtions)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] > 1) {
        id obj = self[[indexPath indexAtPosition:0]];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSUInteger *indexes = calloc(indexPath.length , sizeof(NSUInteger));
            [indexPath getIndexes:indexes];
            id retVal = [obj objectAtIndexPath:[NSIndexPath indexPathWithIndexes:&indexes[1] length:[indexPath length] - 1]];
            free(indexes);
            return retVal;
        } else {
            return nil;
        }
    } else {
        return self[[indexPath indexAtPosition:0]];
    }
}

@end
