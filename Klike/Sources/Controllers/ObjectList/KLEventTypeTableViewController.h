//
//  KLObjectListTableViewController.h
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KLEventTypeDelegate <NSObject>

- (void)didSelectType:(NSUInteger)type;

@end

@interface KLEventTypeTableViewController : UITableViewController

@property (nonatomic, strong) id<KLEventTypeDelegate> delegate;

- (instancetype)initWithDefaultValue:(NSUInteger)defaultValue;

@end
