//
//  KLEmailComposer.h
//  Klike
//
//  Created by Alexey on 7/30/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEmailComposer : NSObject

+ (NSString *)emailBodyWithEvent:(KLEvent *)event file:(NSString *)htmlFileName;

@end
