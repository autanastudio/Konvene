//
//  KLEnumViewController.h
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLEnumViewController;

@protocol KLEnumViewControllerDelegate <NSObject>

- (void)enumViewController:(KLEnumViewController *)controller
            didSelectValue:(KLEnumObject *)value;

@end

@interface KLEnumViewController : UITableViewController

@property (nonatomic, strong) id<KLEnumViewControllerDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)titleString
                 defaultvalue:(KLEnumObject *)defaultValue
                  enumObjects:(NSArray *)enumObjects;

@end
