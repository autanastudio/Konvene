//
//  KLPrivacyControllerTableViewController.h
//  Klike
//
//  Created by Dima on 08.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KLEventPrivacyDelegate <NSObject>

- (void)didSelectPrivacy:(NSUInteger)privacy;

@end


@interface KLPrivacyTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<KLEventPrivacyDelegate> delegate;

- (instancetype)initWithPrivacy:(NSUInteger)privacy;

@end
