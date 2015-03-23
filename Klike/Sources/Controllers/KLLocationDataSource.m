//
//  KLLocationDataSource.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocationDataSource.h"
#import "KLForsquareVenue.h"
#import "KLLocationCell.h"

@interface KLLocationDataSource ()

@property (nonatomic, strong) KLForsquareVenue *customLocation;

@end

static NSString *klLocationCellIdentifier = @"KLLocationCell";

@implementation KLLocationDataSource

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        [self.manager requestWhenInUseAuthorization];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    UINib *nib = [UINib nibWithNibName:klLocationCellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:klLocationCellIdentifier];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                   inSection:indexPath.section];
    return [super itemAtIndexPath:indexPath];
}

- (BOOL)shouldDisplayPlaceholder
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLLocationCell *cell = (KLLocationCell *)[tableView dequeueReusableCellWithIdentifier:klLocationCellIdentifier
                                                                             forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell configureWithVenue:nil];
    } else {
        KLForsquareVenue *venue = [self itemAtIndexPath:indexPath];
        [cell configureWithVenue:venue];
    }
    return cell;
}

- (void)loadContent
{
    __weak typeof(self) weakSelf = self;
    [self loadContentWithBlock:^(SFLoading *loading) {
        
        CLLocationCoordinate2D coordinate = weakSelf.manager.location.coordinate;
        [Foursquare2 venueSuggestCompletionByLatitude:[NSNumber numberWithDouble:coordinate.latitude]
                                            longitude:[NSNumber numberWithDouble:coordinate.longitude]
                                                 near:nil
                                           accuracyLL:@0
                                             altitude:@0
                                          accuracyAlt:@0
                                                query:weakSelf.input
                                                limit:nil
                                               radius:@0
                                                    s:nil
                                                    w:nil
                                                    n:nil
                                                    e:nil
                                             callback:
         ^(BOOL success, id result) {
             if (!loading.current) {
                 [loading ignore];
                 return;
             }
             
             NSLog(@"Foursqaure: %@", result);
             if ([result isKindOfClass:[NSError class]]) {
                 [loading updateWithNoContent:nil];
             } else {
                 NSDictionary *response = result[@"response"];
                 NSArray *minivenues = response[@"minivenues"];
                 NSError *error;
                 NSArray *result = [MTLJSONAdapter modelsOfClass:[KLForsquareVenue class]
                                                   fromJSONArray:minivenues
                                                           error:&error];
                 if (!error) {
                     [loading updateWithContent:^(KLLocationDataSource *dataSource) {
                         NSMutableArray *results = [NSMutableArray array];
                         [results addObject:weakSelf.customLocation];
                         [results addObjectsFromArray:result];
                         dataSource.items = results;
                     }];
                 }
             }
         }];
    }];
}

- (KLForsquareVenue *)customLocation
{
    if (!_customLocation) {
        _customLocation = [KLForsquareVenue new];
        _customLocation.custom = YES;
    }
    CLLocationCoordinate2D coordinate = self.manager.location.coordinate;
    _customLocation.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    _customLocation.longitude = [NSNumber numberWithDouble:coordinate.longitude];
    return _customLocation;
}


@end
