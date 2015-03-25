//
//  KLLocationCell.h
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLForsquareVenue;

@interface KLLocationCell : UITableViewCell

- (void)configureWithVenue:(KLForsquareVenue *)venue;

@end
