//
//  KLLocationDataSource.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocationDataSource.h"
#import "KLLocationCell.h"
#import "QDGooglePlacesManager.h"

@interface KLLocationDataSource ()

@property (nonatomic, strong) KLLocation *customLocation;
@property (nonatomic, assign) KLLocationSelectType type;
@property (nonatomic, strong) QDGooglePlacesManager *placesManager;

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
        self.placesManager = [[QDGooglePlacesManager alloc] init];
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
        if (weakSelf.type == KLLocationSelectTypeGooglePlaces) {
            CLLocationCoordinate2D coordinate = weakSelf.manager.location.coordinate;
            [self.placesManager getPlacesList:weakSelf.input
                                     location:coordinate
                                   completion:^(NSArray *places, NSError *error) {
                if (!error) {
                    [loading updateWithContent:^(KLLocationDataSource *dataSource) {
                        NSMutableArray *results = [NSMutableArray array];
                        [results addObject:weakSelf.customLocation];
                        [results addObjectsFromArray:places];
                        dataSource.items = results;
                    }];
                }
            }];
        } else if (weakSelf.type == KLLocationSelectTypeParse) {
            PFQuery *query = [KLLocation query];
            [query whereKey:sf_key(city)
             containsString:weakSelf.input];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableArray *results = [NSMutableArray array];
                    objects = [weakSelf makeUniqueCity:objects];
                    for (PFObject *venueObject in objects) {
                        [results addObject:[[KLLocation alloc] initWithObject:venueObject]];
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

- (KLLocation *)customLocation
{
    if (!_customLocation) {
        _customLocation = [KLLocation new];
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
