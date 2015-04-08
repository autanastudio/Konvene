//
//  KLEventTypeTableViewCell.h
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEventTypeTableViewCell : UITableViewCell
@property IBOutlet UIView *_viewSeparator;

- (void)configureWithEvent:(NSString *)event
                  imageSrc:(NSString *)imageSrc;

- (void)configureWithEvent:(NSString *)event
                  imageSrc:(NSString *)imageSrc
               contentMode:(UIViewContentMode)mode;

@end
