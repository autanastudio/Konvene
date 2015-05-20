//
//  KLActivitiesDataSource.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivitiesDataSource.h"
#import "KLPlaceholderCell.h"

@implementation KLActivitiesDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"Your events activity will be here.\nExplore events or create one!"
                                                                  image:[UIImage imageNamed:@"empty_state"]
                                                            buttonTitle:nil
                                                           buttonAction:nil];
    }
    return self;
}

@end
