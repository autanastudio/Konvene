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
@property (nonatomic, assign) KLLocationSelectType type;

@end

static NSString *klLocationCellIdentifier = @"KLLocationCell";

@implementation KLLocationDataSource

-(instancetype)initWithType:(KLLocationSelectType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        self.manager = [[CLLocationManager alloc] init];
        [self.manager requestWhenInUseAuthorization];
        self.placeholderView = [[SFPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"Sorry, nothing found. Please try another location"
                                                                  image:nil
                                                            buttonTitle:nil
                                                           buttonAction:nil];
        self.placeholderView.messageLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    UINib *nib = [UINib nibWithNibName:klLocationCellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:klLocationCellIdentifier];
}

- (BOOL)shouldDisplayPlaceholder
{
    return [self.loadingState isEqualToString:SFLoadStateNoContent];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.obscuredByPlaceholder){
        return [self dequeuePlaceholderViewForTableView:tableView
                                            atIndexPath:indexPath];
    }
    KLLocationCell *cell = (KLLocationCell *)[tableView dequeueReusableCellWithIdentifier:klLocationCellIdentifier
                                                                             forIndexPath:indexPath];
    KLForsquareVenue *venue = [self itemAtIndexPath:indexPath];
    [cell configureWithVenue:venue
                        type:(KLLocationcellType)self.type];
    return cell;
}

- (void)loadContent
{
    __weak typeof(self) weakSelf = self;
    [self loadContentWithBlock:^(SFLoading *loading) {
        if (!self.input.length) {
            [loading updateWithContent:^(KLLocationDataSource *dataSource) {
                if (weakSelf.type == KLLocationcellTypeVenue) {
                    dataSource.items = @[self.customLocation];
                } else if (weakSelf.type == KLLocationcellTypeCity){
                    dataSource.items = [NSArray array];
                }
            }];
            return;
        }
        if (weakSelf.type == KLLocationSelectTypeFoursquare) {
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
        } else if (weakSelf.type == KLLocationSelectTypeParse) {
            PFQuery *query = [KLForsquareVenue query];
            [query whereKey:sf_key(city)
             containsString:weakSelf.input];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableArray *results = [NSMutableArray array];
                    objects = [weakSelf makeUniqueCity:objects];
                    for (PFObject *venueObject in objects) {
                        [results addObject:[[KLForsquareVenue alloc] initWithObject:venueObject]];
                    }
                    [loading updateWithContent:^(KLLocationDataSource *dataSource) {
                        dataSource.items = results;
                    }];
                }
            }];
        }
    }];
}

- (NSArray *)makeUniqueCity:(NSArray *)array
{
    NSMutableArray *uniqueArray = [NSMutableArray array];
    for (PFObject *venueObject in array) {
        BOOL unique = YES;
        for (PFObject *uniqueObject in uniqueArray) {
            if ([venueObject[sf_key(city)] isEqualToString:uniqueObject[sf_key(city)]]) {
                unique = NO;
                break;
            }
        }
        if (unique) {
            [uniqueArray addObject:venueObject];
        }
    }
    return uniqueArray;
}

- (KLForsquareVenue *)customLocation
{
    if (!_customLocation) {
        _customLocation = [KLForsquareVenue new];
        _customLocation.custom = @(YES);
    }
    CLLocationCoordinate2D coordinate = self.manager.location.coordinate;
    _customLocation.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    _customLocation.longitude = [NSNumber numberWithDouble:coordinate.longitude];
    if (self.input.length) {
        _customLocation.name = self.input;
    } else {
        _customLocation.name = SFLocalized(@"kl_unnamed_location");
    }
    return _customLocation;
}


@end
