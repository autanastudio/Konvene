//
//  KLCommentDataSource.h
//  Klike
//
//  Created by Alexey on 5/18/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPagedDataSource.h"

@interface KLCommentDataSource : KLPagedDataSource

- (instancetype)initWithEvent:(KLEvent *)event;

@end
