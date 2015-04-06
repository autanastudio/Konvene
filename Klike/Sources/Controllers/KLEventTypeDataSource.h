//
//  KLObjectListDataSource.h
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFBasicDataSource.h"

@interface KLEventTypeDataSource : SFBasicDataSource

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)getIndexPathForType:(NSString *)eventType;

@end
