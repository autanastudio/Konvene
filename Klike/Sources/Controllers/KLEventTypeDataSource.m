//
//  KLObjectListDataSource.m
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventTypeDataSource.h"
#import "KLEventTypeTableViewCell.h"

@interface KLEventTypeDataSource ()

@property (nonatomic, strong) NSDictionary *eventTypesDictionary;
@end

@implementation KLEventTypeDataSource

static NSString *cellId = @"EventTypeCell";

- (instancetype)init {
    if (self = [super init]) {
        self.eventTypesDictionary = [KLEventTypeDataSource getEventTypesDictionary];
        [self setItems:[self getEventTypesArray]];
    }
    return self;
}

- (NSArray *)getEventTypesArray
{
    return  @[@"None"                                       ,
              @"Birthday"                                   ,
              @"Get Together"                               ,
              @"Meeting"                                    ,
              @"Pool Party"                                 ,
              @"Holiday"                                    ,
              @"Pre-Game"                                   ,
              @"Day Party"                                  ,
              @"Study Session"                              ,
              @"Eating Out"                                 ,
              @"Music Event"                                ,
              @"Trip"                                       ,
              @"Party"];
}

+ (NSDictionary *)getEventTypesDictionary
{
    return                  @{
                              @"None"                                       : @"",
                              @"Birthday"                                   : @"event_type",
                              @"Get Together"                               : @"event_drink",
                              @"Meeting"                                    : @"event_tie",
                              @"Pool Party"                                 : @"event_bikini",
                              @"Holiday"                                    : @"event_baloon",
                              @"Pre-Game"                                   : @"event_ball",
                              @"Day Party"                                  : @"event_sun",
                              @"Study Session"                              : @"event_globe",
                              @"Eating Out"                                 : @"event_food",
                              @"Music Event"                                : @"event_guitar",
                              @"Trip"                                       : @"event_trip",
                              @"Party"                                      : @"event_coktail",
                              };
}


- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"KLEventTypeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLEventTypeTableViewCell *cell = (KLEventTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[KLEventTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellId];
    }
    NSString *key = [self itemAtIndexPath:indexPath];
    NSString *imageSrc = [self.eventTypesDictionary objectForKey:key];
    [cell configureWithEvent:key imageSrc:imageSrc];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    return cell;
}

- (NSIndexPath *)getIndexPathForType:(NSString *)eventType
{
    if (eventType) {
        NSArray *array = [self getEventTypesArray];
        for (int i = 0; i < array.count; i++) {
            if ([[array objectAtIndex:i] isEqualToString:eventType])
                return [NSIndexPath indexPathForRow:i inSection:0];
        }
        return [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath
{
    return [self itemAtIndexPath:indexPath];
}

@end
