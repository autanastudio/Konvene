//
//  KLLocationDataSource.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "SFBasicDataSource.h"

@interface KLLocationDataSource : SFBasicDataSource

@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) CLLocationManager *manager;

@end
