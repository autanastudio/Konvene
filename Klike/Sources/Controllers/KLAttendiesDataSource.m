//
//  KLAttendiesDataSource.m
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAttendiesDataSource.h"

@implementation KLAttendiesDataSource

- (PFQuery *)buildQuery
{
    PFQuery *query = [PFUser query];
    query.limit = 10;
    [query whereKey:sf_key(objectId) containedIn:self.event.attendees];
    return query;
}

@end
